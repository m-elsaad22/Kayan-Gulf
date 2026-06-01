// KAYAN — Notification Service (Firebase-safe)
import 'package:flutter/foundation.dart';
import 'local_storage_service.dart';

abstract class NotificationService {
  static Future<void> initialize() async {
    try {
      await _initFirebaseMessaging();
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ Notifications skipped (Firebase not configured): $e');
    }
  }

  static Future<void> _initFirebaseMessaging() async {
    // Will work once google-services.json is real
    // Firebase.initializeApp() must be called first in main.dart
  }

  static Future<String?> getToken() async {
    try {
      // return await FirebaseMessaging.instance.getToken();
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveToken(String token) async {
    await LocalStorageService.saveFcmToken(token);
  }
}
