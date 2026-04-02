import 'package:flutter/material.dart' show ThemeMode;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
abstract class AppSettings with _$AppSettings {
  factory AppSettings({
    required bool biometricEnabled,
    required ThemeMode themeMode,
    required bool completedOnboarding,
  }) = _AppSettings;

  factory AppSettings.initial() => AppSettings(
    biometricEnabled: false,
    themeMode: ThemeMode.system,
    completedOnboarding: false,
  );

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
