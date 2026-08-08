// KAYAN — Auth State Model (simplified — no code generation needed)
enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthState {
  final String? userId;
  final String? accessToken;
  final String? refreshToken;
  final bool isProfileComplete;
  final AuthStatus status;

  const AuthState._({
    required this.status,
    this.userId,
    this.accessToken,
    this.refreshToken,
    this.isProfileComplete = false,
  });

  factory AuthState.initial() => const AuthState._(status: AuthStatus.initial);
  factory AuthState.loading() => const AuthState._(status: AuthStatus.loading);
  factory AuthState.unauthenticated() => const AuthState._(status: AuthStatus.unauthenticated);
  factory AuthState.authenticated({
    required String userId,
    required String accessToken,
    required String refreshToken,
    required bool isProfileComplete,
  }) => AuthState._(
    status: AuthStatus.authenticated,
    userId: userId,
    accessToken: accessToken,
    refreshToken: refreshToken,
    isProfileComplete: isProfileComplete,
  );

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isInitial => status == AuthStatus.initial;
  bool get isLoading => status == AuthStatus.loading;

  @override
  String toString() => 'AuthState(status: $status, userId: $userId)';
}
