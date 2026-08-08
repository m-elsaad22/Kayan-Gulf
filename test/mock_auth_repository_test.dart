import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/features/auth/data/repositories/mock_auth_repository.dart';

void main() {
  group('MockAuthRepository', () {
    const repo = MockAuthRepository();

    test('sendOtp succeeds for valid phone', () async {
      await expectLater(repo.sendOtp('+966501234567'), completes);
    });

    test('sendOtp rejects short phone', () async {
      expect(
        () => repo.sendOtp('123'),
        throwsA(isA<Exception>()),
      );
    });

    test('verifyOtp returns auth result for valid code', () async {
      final result = await repo.verifyOtp('+966501234567', '123456');
      expect(result.userId, isNotEmpty);
      expect(result.accessToken, isNotEmpty);
      expect(result.refreshToken, isNotEmpty);
      expect(result.isProfileComplete, isFalse);
    });

    test('verifyOtp rejects invalid code length', () async {
      expect(
        () => repo.verifyOtp('+966501234567', '12'),
        throwsA(isA<Exception>()),
      );
    });

    test('loginWithEmail returns authenticated result', () async {
      final result = await repo.loginWithEmail('user@test.com', 'password123');
      expect(result.isProfileComplete, isTrue);
    });

    test('signUp returns new user result', () async {
      final result = await repo.signUp(
        name: 'Test User',
        email: 'new@test.com',
        phone: '+966501234567',
        password: 'password123',
      );
      expect(result.isNewUser, isTrue);
      expect(result.isProfileComplete, isFalse);
    });
  });
}
