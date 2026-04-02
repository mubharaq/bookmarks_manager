import 'dart:async';

import 'package:bookmarks_manager/data/services/push_notifications/notification_setup_service.dart';
import 'package:bookmarks_manager/data/services/push_notifications/push_notifications_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_notification_manager_provider.g.dart';

@riverpod
Stream<String> fcmTokenRefresh(Ref ref) {
  return ref.watch(pushNotificationsServiceProvider).onTokenRefresh;
}

@riverpod
Stream<RemoteMessage> onMessage(Ref ref) {
  return ref.watch(pushNotificationsServiceProvider).onMessage;
}

@riverpod
Stream<RemoteMessage> onMessageOpenedApp(Ref ref) {
  return ref.watch(pushNotificationsServiceProvider).onMessageOpenedApp;
}

@Riverpod(keepAlive: true)
class PushNotificationManager extends _$PushNotificationManager {
  @override
  Future<void> build() async {
    await ref.read(pushNotificationsServiceProvider).initialize();
    ref
      ..listen(fcmTokenRefreshProvider, (_, next) {
        next.whenData(_syncToken);
      })
      ..listen(onMessageProvider, (_, next) {
        next.whenData((message) {
          ref.read(pushNotificationsServiceProvider).showNotification(message);
        });
      });
  }

  Future<RemoteMessage?> onAppReady() async {
    await ensureTokenSynced();
    final initialMessage = await ref
        .read(pushNotificationsServiceProvider)
        .getInitialMessage();
    return initialMessage;
  }

  Future<void> ensureTokenSynced({bool requestIfNeeded = false}) async {
    final service = ref.read(pushNotificationsServiceProvider);
    final setupService = ref.read(notificationSetupServiceProvider);
    final status = requestIfNeeded
        ? await service.requestPermission()
        : await service.checkPermissionStatus();

    if (status != AuthorizationStatus.authorized) return;
    if (!requestIfNeeded && !setupService.shouldSyncToken()) return;

    final token = await service.getToken();
    if (token == null) return;
    await setupService.recordTokenSynced();
    unawaited(_syncToken(token));
  }

  Future<bool> shouldShowPermissionPrompt() async {
    final setupService = ref.read(notificationSetupServiceProvider);
    if (!setupService.shouldShowPrompt()) return false;

    final status = await ref
        .read(pushNotificationsServiceProvider)
        .checkPermissionStatus();

    return status != AuthorizationStatus.authorized;
  }

  Future<void> recordPromptShown() =>
      ref.read(notificationSetupServiceProvider).recordPromptShown();

  Future<void> _syncToken(String token) async {
    // await ref.read(userRepositoryProvider).saveFcmToken(fcmToken: token);
  }
}
