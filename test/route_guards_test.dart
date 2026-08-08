import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/routing/app_routes.dart';
import 'package:kayan/routing/route_guards.dart';

void main() {
  group('RouteGuards.requiresCompleteProfile', () {
    test('checkout and cart require complete profile', () {
      expect(RouteGuards.requiresCompleteProfile(AppRoutes.checkout), isTrue);
      expect(RouteGuards.requiresCompleteProfile(AppRoutes.cart), isTrue);
    });

    test('home does not require complete profile', () {
      expect(RouteGuards.requiresCompleteProfile(AppRoutes.home), isFalse);
      expect(RouteGuards.requiresCompleteProfile(AppRoutes.dashboard), isFalse);
    });

    test('booking confirm requires complete profile', () {
      expect(RouteGuards.requiresCompleteProfile(AppRoutes.bookingConfirm), isTrue);
    });
  });

  group('AuthGuardState', () {
    test('authenticated factory sets flags', () {
      const state = AuthGuardState.authenticated(userId: 'u42', profileComplete: true);
      expect(state.isAuthenticated, isTrue);
      expect(state.isProfileComplete, isTrue);
      expect(state.userId, 'u42');
    });

    test('unauthenticated factory clears user', () {
      const state = AuthGuardState.unauthenticated();
      expect(state.isAuthenticated, isFalse);
      expect(state.userId, isNull);
    });
  });
}
