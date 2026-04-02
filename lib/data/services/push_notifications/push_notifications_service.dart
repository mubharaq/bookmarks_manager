import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_notifications_service.g.dart';

class PushNotificationService {
  PushNotificationService({
    required FirebaseMessaging messaging,
    required FlutterLocalNotificationsPlugin localNotifications,
  }) : _messaging = messaging,
       _localNotifications = localNotifications;

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  Future<RemoteMessage?> getInitialMessage() => _messaging.getInitialMessage();

  Future<void> initialize() async {
    await _configureNotificationChannel();
    await _initializeLocalNotifications();
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus;
  }

  Future<AuthorizationStatus> checkPermissionStatus() async {
    final settings = await _messaging.getNotificationSettings();
    return settings.authorizationStatus;
  }

  Future<String?> getToken() async {
    if (Platform.isIOS) {
      var apnsToken = await _messaging.getAPNSToken();
      if (apnsToken == null) {
        await Future<void>.delayed(const Duration(seconds: 1));
        apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) return null;
      }
    }
    return _messaging.getToken();
  }

  void showNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    if (Platform.isAndroid && notification.android == null) return;

    unawaited(
      _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            icon: 'ic_stat_name',
          ),
          iOS: DarwinNotificationDetails(presentAlert: true),
        ),
      ),
    );
  }

  Future<void> _configureNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _initializeLocalNotifications() async {
    const android = AndroidInitializationSettings('ic_stat_name');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: android, iOS: ios);
    await _localNotifications.initialize(settings: settings);
  }
}

@Riverpod(keepAlive: true)
PushNotificationService pushNotificationsService(
  Ref ref,
) {
  return PushNotificationService(
    messaging: FirebaseMessaging.instance,
    localNotifications: FlutterLocalNotificationsPlugin(),
  );
}
