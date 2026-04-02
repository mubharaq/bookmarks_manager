import 'package:bookmarks_manager/app/providers/auth/auth_state_provider.dart';
import 'package:bookmarks_manager/app/providers/settings/app_settings_provider.dart';
import 'package:bookmarks_manager/app/routing/app_routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_initialization.g.dart';

@riverpod
Future<String> appInitialization(Ref ref) async {
  await Future<void>.delayed(const Duration(seconds: 2));
  final authState = ref.read(authenticationStateProvider);
  final hasCompletedOnboarding = ref
      .read(appSettingsStateProvider)
      .completedOnboarding;
  return switch (authState) {
    Authenticated() => const BookmarksScreenRoute().location,
    Unauthenticated() =>
      hasCompletedOnboarding
          ? const LoginScreenRoute().location
          : const OnboardingScreenRoute().location,
  };
}
