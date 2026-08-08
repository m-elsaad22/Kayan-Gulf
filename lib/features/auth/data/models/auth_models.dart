/// Result of a successful OTP verification or login.
class AuthResult {
  final String userId;
  final String accessToken;
  final String refreshToken;
  final bool isProfileComplete;
  final bool isNewUser;

  const AuthResult({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    this.isProfileComplete = false,
    this.isNewUser = false,
  });

  factory AuthResult.fromJson(Map<String, dynamic> j) => AuthResult(
        userId: j['userId'] as String,
        accessToken: j['accessToken'] as String,
        refreshToken: j['refreshToken'] as String,
        isProfileComplete: j['isProfileComplete'] as bool? ?? false,
        isNewUser: j['isNewUser'] as bool? ?? false,
      );
}
