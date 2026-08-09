import 'package:flutter/foundation.dart';

import 'device_repository.dart';

class MockDeviceRepository implements DeviceRepository {
  @override
  Future<void> registerFcmToken({
    required String token,
    String platform = 'android',
    String? locale,
  }) async {
    if (kDebugMode) {
      debugPrint('[mock] register FCM token ($platform): ${token.substring(0, 8)}…');
    }
  }

  @override
  Future<void> unregisterFcmToken(String token) async {}
}
