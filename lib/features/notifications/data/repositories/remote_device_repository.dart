import '../../../../core/network/api_client.dart';
import 'device_repository.dart';

class RemoteDeviceRepository implements DeviceRepository {
  const RemoteDeviceRepository(this._client);

  final ApiClient _client;

  @override
  Future<void> registerFcmToken({
    required String token,
    String platform = 'android',
    String? locale,
  }) async {
    await _client.postJson(
      '/devices/fcm',
      body: {
        'token': token,
        'platform': platform,
        if (locale != null) 'locale': locale,
      },
    );
  }

  @override
  Future<void> unregisterFcmToken(String token) async {
    await _client.deleteJson(
      '/devices/fcm',
      body: {'token': token},
    );
  }
}
