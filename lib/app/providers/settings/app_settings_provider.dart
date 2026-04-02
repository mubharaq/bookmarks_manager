import 'package:bookmarks_manager/data/services/app_settings/app_settings_service.dart';
import 'package:bookmarks_manager/domain/models/app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_settings_provider.g.dart';

@Riverpod(keepAlive: true)
class AppSettingsState extends _$AppSettingsState {
  @override
  AppSettings build() {
    return ref.read(appSettingsServiceProvider).load();
  }

  Future<void> updateBiometric({required bool biometricEnabled}) async {
    final updated = state.copyWith(biometricEnabled: biometricEnabled);
    await ref.read(appSettingsServiceProvider).save(updated);
    state = updated;
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    final updated = state.copyWith(themeMode: themeMode);
    await ref.read(appSettingsServiceProvider).save(updated);
    state = updated;
  }

  Future<void> updateOnboardingStatus({
    required bool completedOnboarding,
  }) async {
    final updated = state.copyWith(completedOnboarding: completedOnboarding);
    await ref.read(appSettingsServiceProvider).save(updated);
    state = updated;
  }
}
