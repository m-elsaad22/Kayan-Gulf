import '../../data/models/auth_models.dart';
import 'auth_repository.dart';

/// Local mock implementation — swap for [RemoteAuthRepository] when API is ready.
class MockAuthRepository implements AuthRepository {
  const MockAuthRepository();

  @override
  Future<void> sendOtp(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
    if (phone.length < 8) {
      throw Exception('invalid_phone');
    }
  }

  @override
  Future<AuthResult> verifyOtp(String phone, String code) async {
    await Future.delayed(const Duration(seconds: 1));
    if (code.length != 6) {
      throw Exception('invalid_code');
    }
    if (code == '000000') {
      throw Exception('expired_code');
    }
    return AuthResult(
      userId: 'phone-${phone.hashCode.abs()}',
      accessToken: 'mock-phone-token',
      refreshToken: 'mock-phone-refresh',
      isProfileComplete: false,
      isNewUser: true,
    );
  }

  @override
  Future<AuthResult> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (email.isEmpty || password.length < 6) {
      throw Exception('invalid_credentials');
    }
    final userId = 'email-${email.hashCode.abs()}';
    return AuthResult(
      userId: userId,
      accessToken: 'mock-access-$userId',
      refreshToken: 'mock-refresh-$userId',
      isProfileComplete: true,
    );
  }

  @override
  Future<AuthResult> loginWithGoogle({
    required String email,
    String? idToken,
    String? displayName,
    String? googleId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final normalized = email.trim().toLowerCase();
    if (normalized.isEmpty || !normalized.contains('@')) {
      throw Exception('invalid_google_email');
    }
    final userId = googleId?.isNotEmpty == true
        ? 'google-$googleId'
        : 'gmail-${normalized.hashCode.abs()}';
    return AuthResult(
      userId: userId,
      accessToken: 'mock-google-$userId',
      refreshToken: 'mock-google-refresh-$userId',
      isProfileComplete: true,
      isNewUser: false,
    );
  }

  @override
  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final userId = 'signup-${email.hashCode.abs()}';
    return AuthResult(
      userId: userId,
      accessToken: 'mock-access-$userId',
      refreshToken: 'mock-refresh-$userId',
      isProfileComplete: false,
      isNewUser: true,
    );
  }

  @override
  Future<AuthResult> refreshToken(String refreshToken) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return AuthResult(
      userId: 'refreshed-user',
      accessToken: 'mock-refreshed-access',
      refreshToken: refreshToken,
      isProfileComplete: true,
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
