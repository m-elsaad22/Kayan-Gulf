// ============================================================
// KAYAN — Auth State Provider
// lib/shared/providers/auth_provider.dart
//
// Manages the complete authentication lifecycle:
//   - Token persistence (SecureStorage)
//   - OTP send / verify
//   - Token refresh
//   - Logout
// ============================================================

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/repository_providers.dart';
import '../../features/auth/data/models/auth_models.dart';
import '../services/local_storage_service.dart';
import '../services/notification_service.dart';

// ──────────────────────────────────────────────────────────────
// LIGHTWEIGHT AUTH STATE (used by router guard)
// No freezed dependency — keeps routing fast
// ──────────────────────────────────────────────────────────────

class AuthGuardState {
  final bool isAuthenticated;
  final bool isProfileComplete;
  final bool isGuest;
  final String? userId;

  const AuthGuardState({
    this.isAuthenticated    = false,
    this.isProfileComplete  = false,
    this.isGuest            = false,
    this.userId,
  });

  const AuthGuardState.authenticated({
    required String this.userId,
    required bool profileComplete,
  })  : isAuthenticated   = true,
        isProfileComplete = profileComplete,
        isGuest           = false;

  const AuthGuardState.guest()
      : isAuthenticated   = false,
        isProfileComplete = false,
        isGuest           = true,
        userId            = null;

  const AuthGuardState.unauthenticated()
      : isAuthenticated   = false,
        isProfileComplete = false,
        isGuest           = false,
        userId            = null;
}

// ──────────────────────────────────────────────────────────────
// AUTH NOTIFIER
// ──────────────────────────────────────────────────────────────

class AuthNotifier extends Notifier<AuthGuardState> {
  @override
  AuthGuardState build() {
    // Read persisted auth on boot
    final token = LocalStorageService.accessToken;
    final uid   = LocalStorageService.userId;

    if (token != null && uid != null) {
      return AuthGuardState.authenticated(
        userId:         uid,
        profileComplete: LocalStorageService.isProfileComplete,
      );
    }
    if (LocalStorageService.isGuestMode) {
      return const AuthGuardState.guest();
    }
    return const AuthGuardState.unauthenticated();
  }

  Future<void> loginWithEmail(String email, String password) async {
    final result = await ref.read(authRepositoryProvider).loginWithEmail(email, password);
    await _completeAuth(result);
  }

  Future<void> loginWithGoogle() async => _completeMockAuth('google-user');
  Future<void> loginWithApple() async => _completeMockAuth('apple-user');
  Future<void> loginWithFacebook() async => _completeMockAuth('facebook-user');

  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final result = await ref.read(authRepositoryProvider).signUp(
          name: name,
          email: email,
          phone: phone,
          password: password,
        );
    await _completeAuth(result);
  }

  Future<void> continueAsGuest() async {
    await LocalStorageService.markOnboardingSeen();
    await LocalStorageService.setGuestMode(true);
    state = const AuthGuardState.guest();
  }

  Future<void> _completeAuth(AuthResult result) async {
    await LocalStorageService.markOnboardingSeen();
    setAuthenticated(
      userId: result.userId,
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
      isProfileComplete: result.isProfileComplete,
    );
    await _syncDeviceToken();
  }

  Future<void> _completeMockAuth(String userId) async {
    await LocalStorageService.markOnboardingSeen();
    setAuthenticated(
      userId: userId,
      accessToken: 'mock-access-$userId',
      refreshToken: 'mock-refresh-$userId',
      isProfileComplete: true,
    );
  }

  // Called after successful OTP verification
  void setAuthenticated({
    required String userId,
    required String accessToken,
    required String refreshToken,
    required bool isProfileComplete,
  }) {
    LocalStorageService.saveAuth(
      userId:         userId,
      accessToken:    accessToken,
      refreshToken:   refreshToken,
      profileComplete: isProfileComplete,
    );
    state = AuthGuardState.authenticated(
      userId:         userId,
      profileComplete: isProfileComplete,
    );
  }

  // Called after profile setup completes
  void markProfileComplete() {
    LocalStorageService.setProfileComplete(true);
    if (state.userId != null) {
      state = AuthGuardState.authenticated(
        userId:         state.userId!,
        profileComplete: true,
      );
    }
  }

  // Called on logout
  Future<void> logout() async {
    final token = LocalStorageService.fcmToken;
    if (token != null && token.isNotEmpty) {
      try {
        await ref.read(deviceRepositoryProvider).unregisterFcmToken(token);
      } catch (e) {
        if (kDebugMode) debugPrint('FCM unregister failed: $e');
      }
    }
    await ref.read(authRepositoryProvider).logout();
    LocalStorageService.clearAuth();
    state = const AuthGuardState.unauthenticated();
  }

  Future<void> _syncDeviceToken() async {
    final token =
        LocalStorageService.fcmToken ?? await NotificationService.getToken();
    if (token == null || token.isEmpty) return;
    try {
      await ref.read(deviceRepositoryProvider).registerFcmToken(
            token: token,
            platform: NotificationService.platformName(),
          );
    } catch (e) {
      if (kDebugMode) debugPrint('FCM register failed: $e');
    }
  }
}

// ──────────────────────────────────────────────────────────────
// PROVIDERS
// ──────────────────────────────────────────────────────────────

/// Primary auth state provider — watched by GoRouter redirect
final authStateProvider =
    NotifierProvider<AuthNotifier, AuthGuardState>(AuthNotifier.new);

/// Convenience: is user logged in?
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});

/// Convenience: current user ID
final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).userId;
});
