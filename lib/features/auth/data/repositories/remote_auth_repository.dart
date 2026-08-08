import '../../../../core/network/api_client.dart';
import '../../data/models/auth_models.dart';
import 'auth_repository.dart';

/// HTTP implementation — ready to connect when backend is live.
class RemoteAuthRepository implements AuthRepository {
  const RemoteAuthRepository(this._client);

  final ApiClient _client;

  @override
  Future<void> sendOtp(String phone) async {
    await _client.postJson('/auth/otp/send', body: {'phone': phone});
  }

  @override
  Future<AuthResult> verifyOtp(String phone, String code) async {
    final json = await _client.postJson(
      '/auth/otp/verify',
      body: {'phone': phone, 'code': code},
    );
    return AuthResult.fromJson(json);
  }

  @override
  Future<AuthResult> loginWithEmail(String email, String password) async {
    final json = await _client.postJson(
      '/auth/login',
      body: {'email': email, 'password': password},
    );
    return AuthResult.fromJson(json);
  }

  @override
  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final json = await _client.postJson(
      '/auth/signup',
      body: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      },
    );
    return AuthResult.fromJson(json);
  }

  @override
  Future<AuthResult> refreshToken(String refreshToken) async {
    final json = await _client.postJson(
      '/auth/refresh',
      body: {'refreshToken': refreshToken},
    );
    return AuthResult.fromJson(json);
  }

  @override
  Future<void> logout() async {
    await _client.postJson('/auth/logout');
  }
}
