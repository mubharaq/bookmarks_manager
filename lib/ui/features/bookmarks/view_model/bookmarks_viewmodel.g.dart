// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmarks_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Bookmarks)
final bookmarksProvider = BookmarksProvider._();

final class BookmarksProvider
    extends $AsyncNotifierProvider<Bookmarks, BookmarksState> {
  BookmarksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookmarksProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookmarksHash();

  @$internal
  @override
  Bookmarks create() => Bookmarks();
}

String _$bookmarksHash() => r'ee71468ae84aad61959bd09136300b0d3f972e73';

abstract class _$Bookmarks extends $AsyncNotifier<BookmarksState> {
  FutureOr<BookmarksState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BookmarksState>, BookmarksState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BookmarksState>, BookmarksState>,
              AsyncValue<BookmarksState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(BookmarksViewModel)
final bookmarksViewModelProvider = BookmarksViewModelProvider._();

final class BookmarksViewModelProvider
    extends $NotifierProvider<BookmarksViewModel, void> {
  BookmarksViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookmarksViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookmarksViewModelHash();

  @$internal
  @override
  BookmarksViewModel create() => BookmarksViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$bookmarksViewModelHash() =>
    r'5204e455a9d34e7589e90f4d8f4cc60f598c9010';

abstract class _$BookmarksViewModel extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
