// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  biometricEnabled: json['biometricEnabled'] as bool,
  themeMode: $enumDecode(_$ThemeModeEnumMap, json['themeMode']),
  completedOnboarding: json['completedOnboarding'] as bool,
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'biometricEnabled': instance.biometricEnabled,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'completedOnboarding': instance.completedOnboarding,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
