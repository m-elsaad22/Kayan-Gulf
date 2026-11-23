// ============================================================
// KAYAN — Hive-based Local Auth Repository
// Stores real user accounts on the device using Hive.
// Validates credentials on login — no auto-login.
// ============================================================

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'auth_repository.dart';
import '../models/auth_models.dart';
import '../../../../shared/services/local_storage_service.dart';

class HiveAuthRepository implements AuthRepository {
  static const _boxName = 'kayan_users';

  /// Open (or reuse) the users box
  Future<Box<Map>> _box() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<Map>(_boxName);
    }
    return await Hive.openBox<Map>(_boxName);
  }

  /// Very simple "hash" — base64(email+":"+password).
  /// Good enough for local storage. For production, use bcrypt/SHA-256.
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return base64Encode(bytes);
  }

  @override
  Future<AuthResult> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (email.isEmpty || !email.contains('@')) {
      throw Exception('invalid_email');
    }
    if (password.length < 6) {
      throw Exception('password_too_short');
    }

    final box = await _box();
    final key = email.trim().toLowerCase();
    final userData = box.get(key);

    if (userData == null) {
      throw Exception('user_not_found');
    }

    final storedHash = userData['password'] as String?;
    final inputHash = _hashPassword(password);

    if (storedHash != inputHash) {
      throw Exception('wrong_password');
    }

    final userId = userData['id'] as String;

    // Persist profile fields so screens can read them without re-querying Hive
    await LocalStorageService.saveAuth(
      userId:          userId,
      accessToken:     'local-token-$userId',
      refreshToken:    'local-refresh-$userId',
      profileComplete: true,
      userName:        userData['name']  as String?,
      userEmail:       userData['email'] as String?,
      userPhone:       userData['phone'] as String?,
    );

    return AuthResult(
      userId:          userId,
      accessToken:     'local-token-$userId',
      refreshToken:    'local-refresh-$userId',
      isProfileComplete: true,
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

    if (name.trim().isEmpty) throw Exception('name_required');
    if (!email.contains('@')) throw Exception('invalid_email');
    if (phone.length < 8) throw Exception('invalid_phone');
    if (password.length < 6) throw Exception('password_too_short');

    final box = await _box();
    final key = email.trim().toLowerCase();

    if (box.containsKey(key)) {
      throw Exception('email_already_exists');
    }

    final userId = 'user-${DateTime.now().millisecondsSinceEpoch}';

    await box.put(key, {
      'id': userId,
      'name': name.trim(),
      'email': key,
      'phone': phone.trim(),
      'password': _hashPassword(password),
      'createdAt': DateTime.now().toIso8601String(),
    });

    // Persist profile fields so screens can read them without re-querying Hive
    await LocalStorageService.saveAuth(
      userId:          userId,
      accessToken:     'local-token-$userId',
      refreshToken:    'local-refresh-$userId',
      profileComplete: true,
      userName:        name.trim(),
      userEmail:       key,
      userPhone:       phone.trim(),
    );

    return AuthResult(
      userId:          userId,
      accessToken:     'local-token-$userId',
      refreshToken:    'local-refresh-$userId',
      isProfileComplete: true,
      isNewUser: true,
    );
  }

  @override
  Future<void> sendOtp(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
    if (phone.length < 8) throw Exception('invalid_phone');
    // In a real app, send SMS OTP here
  }

  @override
  Future<AuthResult> verifyOtp(String phone, String code) async {
    await Future.delayed(const Duration(seconds: 1));
    if (code.length != 6) throw Exception('invalid_code');
    if (code == '000000') throw Exception('expired_code');

    final userId = 'phone-${phone.hashCode.abs()}';
    return AuthResult(
      userId: userId,
      accessToken: 'local-phone-$userId',
      refreshToken: 'local-refresh-$userId',
      isProfileComplete: true,
      isNewUser: true,
    );
  }

  @override
  Future<AuthResult> refreshToken(String refreshToken) async {
    return AuthResult(
      userId: 'refreshed',
      accessToken: 'refreshed-$refreshToken',
      refreshToken: refreshToken,
      isProfileComplete: true,
    );
  }

  @override
  Future<void> logout() async {
    // Nothing to clean on server side for local auth
  }
}
