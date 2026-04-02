import 'package:bookmarks_manager/data/services/storage/storage_keys.dart';
import 'package:bookmarks_manager/data/services/storage/storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_setup_service.g.dart';

class NotificationSetupService {
  const NotificationSetupService(this._localStorage);

  final LocalStorageService _localStorage;

  bool shouldShowPrompt() {
    final lastPrompt = _localStorage.getStringData(
      StorageKeys.lastNotificationPrompt,
    );
    if (lastPrompt == null) return true;

    final lastPromptTime = DateTime.tryParse(lastPrompt);
    if (lastPromptTime == null) return true;

    return DateTime.now().difference(lastPromptTime).inDays >= 3;
  }

  Future<void> recordPromptShown() async {
    await _localStorage.saveData(
      key: StorageKeys.lastNotificationPrompt,
      value: DateTime.now().toIso8601String(),
    );
  }

  bool shouldSyncToken() {
    final lastSync = _localStorage.getStringData(StorageKeys.lastTokenSync);
    if (lastSync == null) return true;
    final lastSyncTime = DateTime.tryParse(lastSync);
    if (lastSyncTime == null) return true;
    return DateTime.now().difference(lastSyncTime).inHours >= 24;
  }

  Future<void> recordTokenSynced() => _localStorage.saveData(
    key: StorageKeys.lastTokenSync,
    value: DateTime.now().toIso8601String(),
  );
}

@riverpod
NotificationSetupService notificationSetupService(
  Ref ref,
) {
  final localStorage = ref.read(localStorageProvider);
  return NotificationSetupService(localStorage);
}
