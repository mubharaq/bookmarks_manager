import 'dart:convert';

import 'package:bookmarks_manager/data/services/storage/storage_keys.dart';
import 'package:bookmarks_manager/data/services/storage/storage_service.dart';
import 'package:bookmarks_manager/domain/models/user/user.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_storage_service.g.dart';

class AuthStorageService {
  const AuthStorageService(this._localStorage);

  final LocalStorageService _localStorage;
  Logger get _log => Logger('AuthStorageService');

  ({User user, String accessToken})? loadAuthState() {
    final token = _localStorage.getStringData(StorageKeys.authToken);
    if (token == null || token.isEmpty) return null;

    final userJson = _localStorage.getStringData(StorageKeys.currentUser);
    if (userJson == null || userJson.isEmpty) return null;

    try {
      final user = User.fromJson(
        jsonDecode(userJson) as Map<String, dynamic>,
      );
      return (user: user, accessToken: token);
    } on FormatException catch (error) {
      _log.severe('Failed to parse stored user', error);
      return null;
    }
  }

  Future<void> saveAuthState({
    required User user,
    required String token,
  }) async {
    await _localStorage.saveData(
      key: StorageKeys.authToken,
      value: token,
    );
    await _localStorage.saveData(
      key: StorageKeys.currentUser,
      value: jsonEncode(user),
    );
  }

  Future<void> saveUser(User user) async {
    await _localStorage.saveData(
      key: StorageKeys.currentUser,
      value: jsonEncode(user),
    );
  }

  Future<void> clearUser() async {
    await _localStorage.clearKey(StorageKeys.currentUser);
    await _localStorage.clearKey(StorageKeys.authToken);
  }

  Future<void> clearAll() async {
    await _localStorage.clearAll();
  }
}

@riverpod
AuthStorageService authStorageService(Ref ref) {
  final localStorage = ref.read(localStorageProvider);
  return AuthStorageService(localStorage);
}
