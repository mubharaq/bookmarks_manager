import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'storage_service.g.dart';

class LocalStorageService {
  const LocalStorageService({required this.sharedPrefs});

  final SharedPreferences sharedPrefs;

  Future<bool> saveData({
    required String key,
    required Object value,
  }) async {
    return switch (value) {
      final String value => sharedPrefs.setString(key, value),
      final int value => sharedPrefs.setInt(key, value),
      final double value => sharedPrefs.setDouble(key, value),
      final bool value => sharedPrefs.setBool(key, value),
      final List<String> value => sharedPrefs.setStringList(key, value),
      _ => throw FormatException(
        '''Unsupported type: ${value.runtimeType}. Supported types: String, int, double, bool, List<String>.''',
      ),
    };
  }

  int? getIntData(String key) {
    return sharedPrefs.getInt(key);
  }

  String? getStringData(String key) {
    return sharedPrefs.getString(key);
  }

  bool? getBoolData(String key) {
    return sharedPrefs.getBool(key);
  }

  Future<bool> clearAll() async {
    return sharedPrefs.clear();
  }

  Future<bool> clearKey(String key) async {
    return sharedPrefs.remove(key);
  }
}

@Riverpod(keepAlive: true)
SharedPreferences sharedPrefsInstance(
  Ref ref,
) {
  throw UnimplementedError();
}

@Riverpod(keepAlive: true)
LocalStorageService localStorage(
  Ref ref,
) {
  final sharedPrefs = ref.watch(sharedPrefsInstanceProvider);
  return LocalStorageService(sharedPrefs: sharedPrefs);
}
