// KAYAN — Notification Service (Firebase-safe)
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../core/firebase/firebase_bootstrap.dart';
import 'local_storage_service.dart';

@pragma('vm:entry-point')
Future<void> kayanFirebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  if (kDebugMode) {
    debugPrint('FCM background: ${message.messageId}');
  }
}

/// Push notifications via FCM when Firebase is enabled.
abstract class NotificationService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    if (!FirebaseBootstrap.isReady) {
      if (kDebugMode) {
        debugPrint('Notifications skipped (Firebase not ready)');
      }
      return;
    }

    try {
      final messaging = FirebaseMessaging.instance;
      FirebaseMessaging.onBackgroundMessage(
        kayanFirebaseMessagingBackgroundHandler,
      );

      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (kDebugMode) {
        debugPrint('FCM permission: ${settings.authorizationStatus}');
      }

      final token = await messaging.getToken();
      if (token != null && token.isNotEmpty) {
        await saveToken(token);
        if (kDebugMode) debugPrint('FCM token acquired');
      }

      messaging.onTokenRefresh.listen(saveToken);

      FirebaseMessaging.onMessage.listen((message) {
        if (kDebugMode) {
          debugPrint(
            'FCM foreground: ${message.notification?.title} '
            '${message.notification?.body}',
          );
        }
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Notifications skipped (Firebase not configured): $e');
      }
    }
  }

  static Future<String?> getToken() async {
    try {
      if (!FirebaseBootstrap.isReady) return LocalStorageService.fcmToken;
      return await FirebaseMessaging.instance.getToken();
    } catch (_) {
      return LocalStorageService.fcmToken;
    }
  }

  static Future<void> saveToken(String token) async {
    await LocalStorageService.saveFcmToken(token);
  }

  static String platformName() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.android:
        return 'android';
      default:
        return 'android';
    }
  }
}
