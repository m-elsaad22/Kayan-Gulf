// KAYAN — Auth State Model (simplified — no code generation needed)
class AuthState {
  final String? userId;
  final String? accessToken;
  final String? refreshToken;
  final bool isProfileComplete;
  final _AuthStatus status;

  const AuthState._({
    required this.status,
    this.userId,
    this.accessToken,
    this.refreshToken,
    this.isProfileComplete = false,
  });

  factory AuthState.initial() => const AuthState._(status: _AuthStatus.initial);
  factory AuthState.loading() => const AuthState._(status: _AuthStatus.loading);
  factory AuthState.unauthenticated() => const AuthState._(status: _AuthStatus.unauthenticated);
  factory AuthState.authenticated({
    required String userId,
    required String accessToken,
    required String refreshToken,
    required bool isProfileComplete,
  }) => AuthState._(
    status: _AuthStatus.authenticated,
    userId: userId,
    accessToken: accessToken,
    refreshToken: refreshToken,
    isProfileComplete: isProfileComplete,
  );

  bool get isAuthenticated => status == _AuthStatus.authenticated;
  bool get isInitial => status == _AuthStatus.initial;
  bool get isLoading => status == _AuthStatus.loading;

  @override
  String toString() => 'AuthState(status: $status, userId: $userId)';
}

enum _AuthStatus { initial, loading, authenticated, unauthenticated }
