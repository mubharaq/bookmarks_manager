import 'dart:convert';

import 'package:bookmarks_manager/data/services/storage/storage_keys.dart';
import 'package:bookmarks_manager/data/services/storage/storage_service.dart';
import 'package:bookmarks_manager/domain/models/app_settings/app_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_settings_service.g.dart';

class AppSettingsService {
  const AppSettingsService(this._localStorage);

  final LocalStorageService _localStorage;

  AppSettings load() {
    final json = _localStorage.getStringData(StorageKeys.settings);
    if (json == null || json.isEmpty) return AppSettings.initial();

    try {
      return AppSettings.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );
    } on FormatException {
      return AppSettings.initial();
    }
  }

  Future<void> save(AppSettings settings) async {
    await _localStorage.saveData(
      key: StorageKeys.settings,
      value: jsonEncode(settings.toJson()),
    );
  }
}

@riverpod
AppSettingsService appSettingsService(Ref ref) {
  final localStorage = ref.read(localStorageProvider);
  return AppSettingsService(localStorage);
}
