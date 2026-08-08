import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/shared/models/auth_state.dart';

void main() {
  group('AuthState', () {
    test('initial state flags', () {
      final state = AuthState.initial();
      expect(state.isInitial, isTrue);
      expect(state.isAuthenticated, isFalse);
      expect(state.isLoading, isFalse);
      expect(state.userId, isNull);
    });

    test('authenticated state carries user data', () {
      final state = AuthState.authenticated(
        userId: 'u1',
        accessToken: 'access',
        refreshToken: 'refresh',
        isProfileComplete: true,
      );
      expect(state.isAuthenticated, isTrue);
      expect(state.userId, 'u1');
      expect(state.isProfileComplete, isTrue);
    });

    test('unauthenticated state', () {
      final state = AuthState.unauthenticated();
      expect(state.isAuthenticated, isFalse);
      expect(state.status, AuthStatus.unauthenticated);
    });
  });
}
