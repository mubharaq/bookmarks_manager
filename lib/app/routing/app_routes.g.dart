// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $splashScreenRoute,
  $onboardingScreenRoute,
  $registerScreenRoute,
  $loginScreenRoute,
  $resetPasswordRoute,
  $dashboardShellRoute,
];

RouteBase get $splashScreenRoute => GoRouteData.$route(
  path: '/splashscreen',
  factory: $SplashScreenRoute._fromState,
);

mixin $SplashScreenRoute on GoRouteData {
  static SplashScreenRoute _fromState(GoRouterState state) =>
      const SplashScreenRoute();

  @override
  String get location => GoRouteData.$location('/splashscreen');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $onboardingScreenRoute => GoRouteData.$route(
  path: '/onboarding',
  factory: $OnboardingScreenRoute._fromState,
);

mixin $OnboardingScreenRoute on GoRouteData {
  static OnboardingScreenRoute _fromState(GoRouterState state) =>
      const OnboardingScreenRoute();

  @override
  String get location => GoRouteData.$location('/onboarding');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $registerScreenRoute => GoRouteData.$route(
  path: '/register',
  factory: $RegisterScreenRoute._fromState,
);

mixin $RegisterScreenRoute on GoRouteData {
  static RegisterScreenRoute _fromState(GoRouterState state) =>
      const RegisterScreenRoute();

  @override
  String get location => GoRouteData.$location('/register');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginScreenRoute =>
    GoRouteData.$route(path: '/login', factory: $LoginScreenRoute._fromState);

mixin $LoginScreenRoute on GoRouteData {
  static LoginScreenRoute _fromState(GoRouterState state) =>
      const LoginScreenRoute();

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $resetPasswordRoute => GoRouteData.$route(
  path: '/reset-password',
  factory: $ResetPasswordRoute._fromState,
);

mixin $ResetPasswordRoute on GoRouteData {
  static ResetPasswordRoute _fromState(GoRouterState state) =>
      const ResetPasswordRoute();

  @override
  String get location => GoRouteData.$location('/reset-password');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $dashboardShellRoute => ShellRouteData.$route(
  navigatorKey: DashboardShellRoute.$navigatorKey,
  factory: $DashboardShellRouteExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: '/home',
      name: 'home',
      factory: $BookmarksScreenRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/collections',
      name: 'collections',
      factory: $CollectionsScreenRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/account',
      name: 'account',
      factory: $AccountScreenRoute._fromState,
    ),
  ],
);

extension $DashboardShellRouteExtension on DashboardShellRoute {
  static DashboardShellRoute _fromState(GoRouterState state) =>
      const DashboardShellRoute();
}

mixin $BookmarksScreenRoute on GoRouteData {
  static BookmarksScreenRoute _fromState(GoRouterState state) =>
      const BookmarksScreenRoute();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CollectionsScreenRoute on GoRouteData {
  static CollectionsScreenRoute _fromState(GoRouterState state) =>
      const CollectionsScreenRoute();

  @override
  String get location => GoRouteData.$location('/collections');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AccountScreenRoute on GoRouteData {
  static AccountScreenRoute _fromState(GoRouterState state) =>
      const AccountScreenRoute();

  @override
  String get location => GoRouteData.$location('/account');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
