import 'dart:async';
import 'dart:developer';

import 'package:bookmarks_manager/app/app.dart';
import 'package:bookmarks_manager/app/config/app_config.dart';
import 'package:bookmarks_manager/app/providers/provider_observer.dart';
import 'package:bookmarks_manager/data/services/storage/storage_service.dart';
import 'package:bookmarks_manager/domain/error/app_exception.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling a background message ${message.messageId}');
}

Future<void> bootstrap(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPrefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  FlutterError.onError = (errorDetails) {
    unawaited(
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails),
    );
  };
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    ProviderScope(
      overrides: [sharedPrefsInstanceProvider.overrideWithValue(sharedPrefs)],
      observers: [ProviderLogger()],
      retry: (retryCount, error) {
        if (error is AppException) {
          return null; // Don't retry business logic errors
        }
        if (retryCount >= 3) return null; // Max 3 retries for network issues
        return Duration(milliseconds: 200 * (1 << retryCount));
      },
      child: const App(),
    ),
  );
}
