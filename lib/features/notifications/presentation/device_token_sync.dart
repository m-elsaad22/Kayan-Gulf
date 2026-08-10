import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/repository_providers.dart';
import '../../../shared/services/local_storage_service.dart';
import '../../../shared/services/notification_service.dart';

/// Registers the local FCM token with the backend after login.
Future<void> syncDeviceToken(WidgetRef ref, {String? locale}) async {
  final token =
      LocalStorageService.fcmToken ?? await NotificationService.getToken();
  if (token == null || token.isEmpty) return;

  try {
    await ref.read(deviceRepositoryProvider).registerFcmToken(
          token: token,
          platform: NotificationService.platformName(),
          locale: locale,
        );
  } catch (e) {
    if (kDebugMode) debugPrint('Device token sync failed: $e');
  }
}
