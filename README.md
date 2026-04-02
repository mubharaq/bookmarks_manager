# Bookmarks Manager

A Flutter app that demonstrates two things together: generating a real, HTTP-served mock backend from a JSON config file using [`synthetic_api_cli`](https://pub.dev/packages/synthetic_api_cli), and a personal take on how to structure a Flutter app with Riverpod — including it's experimental features.

---

## What This App Is

Bookmarks Manager lets you save and organise URLs across named collections. It supports authentication (login, register, forgot/reset password), push notifications, paginated bookmark lists, and a profile screen with theme switching.

The backend was generated entirely from a JSON schema using `synthetic_api_cli` and deployed on [Render](https://render.com) via the Dockerfile the CLI produces.

---

## Part 1 — The Backend: `synthetic_api_cli`

Most Flutter demos either call a real third-party API or hardcode data in the UI. Both approaches have problems: external APIs limit what you can build, and hardcoded data makes the app feel fake and teaches nothing about how real network calls behave.

[`synthetic_api_cli`](https://pub.dev/packages/synthetic_api_cli) takes a different approach. You describe your API in a JSON configuration file — your endpoints, response shapes, auth rules, relationships — and the CLI generates a fully functional mock backend that:

- Runs over HTTP
- Handles auth, error simulation, latency simulation, pagination, and relational data
- Ships with a `Dockerfile` you can deploy anywhere Docker is supported

For this app, the generated server handles:
- `POST /auth/signup`, `/auth/login`, `/auth/forgot-password`, `/auth/reset-password`
- `GET/POST /bookmarks`, `PATCH/DELETE /bookmarks/:id`
- `GET/POST /categories`, `PATCH/DELETE /categories/:id`
- `GET/PATCH /users/me`
- FCM token registration endpoint

The server was deployed on Render. The Flutter app talks to it exactly like it would talk to a production backend — real HTTP, real JSON, real error responses.

This means every Riverpod pattern in this app is exercised against a real network data.

---

## Part 2 — Flutter Architecture

### Folder Structure

```
lib/
├── app/
│   ├── providers/          # App coordination layer (auth state, push notifications, settings)
│   ├── config/             # App configuration
│   └── routing/            # Go Router + typed routes via go_router_builder
├── data/
│   ├── repositories/       # Network calls, response parsing, Result<T> wrapping
│   └── services/           # Low-level services (API client, storage, push notifications)
├── domain/
│   ├── error/              # AppException, typed error handling
│   ├── models/             # Freezed domain models
│   └── result/             # Result<T> type (Ok/Error)
└── ui/
    ├── core/               # Shared widgets, theme, extensions
    └── features/           # Screen-level code, each with its own viewmodel
```

This is an opinionated structure that i have found to work well for my use cases.

---

### Riverpod Patterns

#### `Mutation<void>` — experimental async actions

For user-triggered async actions (login, add bookmark, delete collection), the app uses `flutter_riverpod/experimental/mutation.dart`. Each discrete action gets its own `Mutation` instance, giving you per-action loading and error state without boilerplate:

```dart
final addBookmarkMutation = Mutation<void>();
final editBookmarkMutation = Mutation<void>();
final deleteBookmarkMutation = Mutation<void>();
```

In the UI, mutations are listened to for error toasts and success side effects, and their `.isPending` is used to disable buttons and show loaders:

```dart
ref.listen(addBookmarkMutation, (_, next) {
  if (next case MutationError(:final error)) {
    context.showErrorToast(error.asErrorMessage);
  }
});

final isLoading = ref.watch(addBookmarkMutation).isPending;
```

The viewmodel methods throw on error so the mutation captures it:

```dart
Future<void> addBookmark({...}) async {
  final response = await ref.read(bookmarksRepositoryProvider).addBookmark(...);
  return response.fold(onOk: (_) {}, onError: (error) => throw error);
}
```

`.suppress()` is a small extension on `Future<void>` that silences the rethrow from `Mutation.run`, since the mutation already holds the error state:

```dart
await addBookmarkMutation.run(ref, (tsx) {
  return tsx.get(bookmarksViewModelProvider.notifier).addBookmark(...);
}).suppress();
```

---

#### State-based viewmodels with Freezed — multi-step flows

Not everything suits mutations. The reset password flow has two steps (email → OTP + new password), two distinct loading states (`isLoading` for the main action, `isResending` for the resend button), and needs to expose an error message reactively. A single freezed state class handles all of this cleanly:

```dart
@freezed
abstract class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState({
    required bool isLoading,
    required bool isResending,
    String? errorMessage,
  }) = _ResetPasswordState;
}
```

Methods return `bool` so the UI can react to success without extra mutation watchers:

```dart
final success = await _viewmodel.requestOtp(email: email);
if (success && mounted) {
  setState(() => _step = 1);
  _startResendTimer();
}
```

Error messages are surfaced via a selective listener that only rebuilds when the error changes:

```dart
ref.listen(
  resetPasswordViewmodelProvider.select((s) => s.errorMessage),
  (_, error) {
    if (error != null) context.showErrorToast(error);
  },
);
```

---

#### `@Riverpod(keepAlive: true)` — persistent app-wide state

Collections and bookmarks are kept alive for the lifetime of the app. Their notifiers expose mutation helpers (`add`, `edit`, `remove`) that update in-memory state immediately, enabling optimistic updates without a full refetch:

```dart
@Riverpod(keepAlive: true)
class Collections extends _$Collections {
  @override
  Future<List<Category>> build() async => _fetchCollections();

  void add(Category category) {
    state = AsyncValue.data([...?state.value, category]);
  }

  void edit({required String id, required Category newCategory}) { ... }
  void remove(String id) { ... }
}
```

For collections, the viewmodel does the update optimistically before the network call and calls `ref.invalidate(collectionsProvider)` on error to revert:

```dart
Future<void> updateCollection({...}) async {
  ref.read(collectionsProvider.notifier).edit(id: id, newCategory: ...); // optimistic
  final response = await repository.updateCategory(...);
  response.fold(
    onOk: (_) {},
    onError: (error) {
      ref.invalidate(collectionsProvider); // revert
      throw error;
    },
  );
}
```

---

#### Paginated `AsyncNotifier` — bookmarks list

The bookmarks list supports infinite scroll via a paginated `AsyncNotifier`. The first page loads on `build()`, and subsequent pages are appended by `loadMore()`. State is a custom `BookmarksState` (freezed) that tracks the current page, pagination status, and the accumulated bookmark list:

```dart
@Riverpod(keepAlive: true)
class Bookmarks extends _$Bookmarks {
  @override
  Future<BookmarksState> build() async {
    final result = await ref.read(bookmarksRepositoryProvider).bookmarks(page: 1);
    return result.fold(onOk: (items) => BookmarksState(bookmarks: items, ...), ...);
  }

  Future<void> loadMore() async {
    // guards against concurrent calls and fetchedAll status
    // appends results, updates nextPage, transitions status
  }
}
```

---

#### Stream providers — push notifications

FCM token refresh and incoming message streams are exposed as Riverpod stream providers in the app coordination layer, not in the data service. This keeps the UI from reaching into `data/` directly and lets the `PushNotificationManager` orchestrate all notification concerns in one place:

```dart
@riverpod
Stream<String> fcmTokenRefresh(Ref ref) {
  return ref.watch(pushNotificationsServiceProvider).onTokenRefresh;
}

@Riverpod(keepAlive: true)
class PushNotificationManager extends _$PushNotificationManager {
  @override
  Future<void> build() async {
    await ref.read(pushNotificationsServiceProvider).initialize();
    ref.listen(fcmTokenRefreshProvider, (_, next) {
      next.whenData(_syncToken);
    });
  }
}
```

Token sync is fire-and-forget (`unawaited`) and frequency-gated via `NotificationSetupService` — passive syncs are skipped if one happened in the last 24 hours:

```dart
Future<void> ensureTokenSynced({bool requestIfNeeded = false}) async {
  if (!requestIfNeeded && !setupService.shouldSyncToken()) return;
  await setupService.recordTokenSynced(); // optimistic timestamp
  unawaited(_syncToken(token));
}
```

---

#### `Result<T>` — typed error propagation

Every repository method returns `Result<T>` instead of throwing or returning nullable types. This makes error handling at call sites explicit and exhaustive:

```dart
return result.fold(
  onOk: (data) => Result.ok(data),
  onError: (error) => Result.error(error),
);
```

Errors flow up as `AppException` instances with a typed `errorMessage` property, which is what the UI ultimately shows in toast messages.

---

#### `ProviderObserver` — state logging

A `ProviderObserver` is wired up in development builds to log provider state changes, making it easy to trace the full chain of state transitions during debugging without adding debug prints throughout the codebase.

---

#### Typed routes — Go Router + `go_router_builder`

All navigation uses typed route classes generated by `go_router_builder`. There are no magic strings anywhere in the routing layer:

```dart
context.go(const BookmarksScreenRoute().location);
const ResetPasswordRoute().push<void>(context);
```

---

## Running the App

```sh
# Development
flutter run --flavor development --target lib/main_development.dart

# Staging
flutter run --flavor staging --target lib/main_staging.dart

# Production
flutter run --flavor production --target lib/main_production.dart
```

## License

MIT
