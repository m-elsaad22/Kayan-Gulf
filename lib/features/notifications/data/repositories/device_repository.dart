abstract class DeviceRepository {
  Future<void> registerFcmToken({
    required String token,
    String platform = 'android',
    String? locale,
  });

  Future<void> unregisterFcmToken(String token);
}
