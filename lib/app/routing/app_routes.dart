import 'package:bookmarks_manager/app/splashscreen.dart';
import 'package:bookmarks_manager/ui/core/app_shell.dart';
import 'package:bookmarks_manager/ui/features/auth/login/login_screen.dart';
import 'package:bookmarks_manager/ui/features/auth/register/register_screen.dart';
import 'package:bookmarks_manager/ui/features/auth/reset_password/reset_password_screen.dart';
import 'package:bookmarks_manager/ui/features/bookmarks/bookmarks_screen.dart';
import 'package:bookmarks_manager/ui/features/collections/collection_screen.dart';
import 'package:bookmarks_manager/ui/features/onboarding/onboarding_screen.dart';
import 'package:bookmarks_manager/ui/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'app_routes.g.dart';

final routerKey = GlobalKey<NavigatorState>(debugLabel: 'routerKey');
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

@TypedGoRoute<SplashScreenRoute>(
  path: '/splashscreen',
)
class SplashScreenRoute extends GoRouteData with $SplashScreenRoute {
  const SplashScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const Splashscreen();
}

@TypedGoRoute<OnboardingScreenRoute>(
  path: '/onboarding',
)
class OnboardingScreenRoute extends GoRouteData with $OnboardingScreenRoute {
  const OnboardingScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OnboardingScreen();
}

@TypedGoRoute<RegisterScreenRoute>(
  path: '/register',
)
class RegisterScreenRoute extends GoRouteData with $RegisterScreenRoute {
  const RegisterScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RegisterScreen();
}

@TypedGoRoute<LoginScreenRoute>(
  path: '/login',
)
class LoginScreenRoute extends GoRouteData with $LoginScreenRoute {
  const LoginScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

@TypedGoRoute<ResetPasswordRoute>(
  path: '/reset-password',
)
class ResetPasswordRoute extends GoRouteData with $ResetPasswordRoute {
  const ResetPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ResetPasswordScreen();
}

@TypedShellRoute<DashboardShellRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<BookmarksScreenRoute>(
      path: '/home',
      name: 'home',
    ),
    TypedGoRoute<CollectionsScreenRoute>(
      path: '/collections',
      name: 'collections',
    ),
    TypedGoRoute<AccountScreenRoute>(
      path: '/account',
      name: 'account',
    ),
  ],
)
class DashboardShellRoute extends ShellRouteData {
  const DashboardShellRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return const AppShell();
  }
}

class BookmarksScreenRoute extends GoRouteData with $BookmarksScreenRoute {
  const BookmarksScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const BookmarksScreen();
}

class AccountScreenRoute extends GoRouteData with $AccountScreenRoute {
  const AccountScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileScreen();
}

class CollectionsScreenRoute extends GoRouteData with $CollectionsScreenRoute {
  const CollectionsScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CollectionScreen();
}
