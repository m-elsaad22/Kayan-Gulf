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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_storage_service.dart';

// ──────────────────────────────────────────────────────────────
// LIGHTWEIGHT AUTH STATE (used by router guard)
// No freezed dependency — keeps routing fast
// ──────────────────────────────────────────────────────────────

class AuthGuardState {
  final bool isAuthenticated;
  final bool isProfileComplete;
  final String? userId;

  const AuthGuardState({
    this.isAuthenticated    = false,
    this.isProfileComplete  = false,
    this.userId,
  });

  const AuthGuardState.authenticated({
    required String userId,
    required bool profileComplete,
  })  : isAuthenticated   = true,
        isProfileComplete = profileComplete,
        userId            = userId;

  const AuthGuardState.unauthenticated()
      : isAuthenticated   = false,
        isProfileComplete = false,
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
    return const AuthGuardState.unauthenticated();
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
  void logout() {
    LocalStorageService.clearAuth();
    state = const AuthGuardState.unauthenticated();
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
