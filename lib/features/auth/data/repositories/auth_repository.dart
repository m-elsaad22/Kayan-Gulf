import '../../data/models/auth_models.dart';

/// Contract for authentication operations.
abstract class AuthRepository {
  Future<void> sendOtp(String phone);

  Future<AuthResult> verifyOtp(String phone, String code);

  Future<AuthResult> loginWithEmail(String email, String password);

  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  Future<AuthResult> refreshToken(String refreshToken);

  Future<void> logout();
}
