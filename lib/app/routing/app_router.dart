import 'package:bookmarks_manager/app/providers/auth/auth_state_provider.dart';
import 'package:bookmarks_manager/app/routing/app_routes.dart';
import 'package:bookmarks_manager/app/routing/router_observer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final Set<String> allowedRoutes = {
  const SplashScreenRoute().location,
  const OnboardingScreenRoute().location,
  const RegisterScreenRoute().location,
  const LoginScreenRoute().location,
  const ResetPasswordRoute().location,
};

bool isAllowedRoute(String currentPath) {
  final pathWithoutQuery = Uri.parse(currentPath).path;
  return allowedRoutes.any(pathWithoutQuery.startsWith);
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final authStateNotifier = ValueNotifier<AuthState>(
    ref.read(authenticationStateProvider),
  );
  ref.listen(authenticationStateProvider, (previous, next) {
    authStateNotifier.value = next;
  });
  final router = GoRouter(
    navigatorKey: routerKey,
    refreshListenable: authStateNotifier,
    initialLocation: const SplashScreenRoute().location,
    debugLogDiagnostics: true,
    routes: $appRoutes,
    observers: [RouterObserver()],
    redirect: (context, state) {
      final authState = authStateNotifier.value;
      final isAllowed = isAllowedRoute(state.uri.path);

      if (authState is Authenticated && isAllowed) {
        return const BookmarksScreenRoute().location;
      }
      if (authState is! Authenticated && !isAllowed) {
        return const LoginScreenRoute().location;
      }
      return null;
    },
  );
  ref
    ..onDispose(authStateNotifier.dispose)
    ..onDispose(router.dispose);

  return router;
}
