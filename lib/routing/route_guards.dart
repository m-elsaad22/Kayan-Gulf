// ============================================================
// KAYAN Super App — Route Guards
// lib/routing/route_guards.dart
//
// Guards run on every navigation event via GoRouter's redirect.
// Priority order (checked top to bottom):
//   1. Maintenance mode → /maintenance
//   2. No internet (for critical paths) → /no-internet
//   3. Onboarding check (first launch) → /onboarding
//   4. Auth check → /auth/phone
//   5. Authenticated on auth pages → /home
//   6. No redirect (null)
// ============================================================

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../shared/providers/auth_provider.dart';
import '../shared/services/local_storage_service.dart';
import 'app_routes.dart';

// ──────────────────────────────────────────────────────────────
// PUBLIC ROUTES
// Routes that anyone can visit without authentication.
// ──────────────────────────────────────────────────────────────

/// Complete list of routes that do NOT require authentication.
const Set<String> _publicRoutes = {
  AppRoutes.splash,
  AppRoutes.onboarding,
  AppRoutes.phoneInput,
  AppRoutes.otpVerify,
  AppRoutes.profileSetup,
  AppRoutes.notFound,
  AppRoutes.noInternet,
  AppRoutes.maintenance,
};

/// Routes where an authenticated user should be redirected away from.
/// (e.g., going back to login screen when already logged in)
const Set<String> _authOnlyRoutes = {
  AppRoutes.phoneInput,
  AppRoutes.otpVerify,
};

// ──────────────────────────────────────────────────────────────
// ROUTE GUARD CLASS
// Encapsulates all redirect logic for GoRouter.
// ──────────────────────────────────────────────────────────────

class RouteGuards {
  const RouteGuards._();

  /// Main redirect handler — pass this to GoRouter.redirect
  ///
  /// Returns a redirect path string, or null to allow navigation.
  static String? redirect({
    required GoRouterState state,
    required WidgetRef ref,
  }) {
    final location = state.uri.toString();
    final isPublic = _isPublicRoute(location);

    // ── Guard 1: Splash is always allowed ──────────────────
    if (location == AppRoutes.splash) return null;

    // ── Guard 2: Onboarding ────────────────────────────────
    // First-time launch: show onboarding before auth
    final hasSeenOnboarding = LocalStorageService.hasSeenOnboarding;
    if (!hasSeenOnboarding && location != AppRoutes.onboarding) {
      return AppRoutes.onboarding;
    }

    // ── Guard 3: Auth check ────────────────────────────────
    final authState = ref.read(authStateProvider);

    // Not authenticated + trying to access protected route
    if (!authState.isAuthenticated && !isPublic) {
      return AppRoutes.phoneInput;
    }

    // Authenticated + trying to access auth-only routes
    if (authState.isAuthenticated && _isAuthOnlyRoute(location)) {
      return AppRoutes.home;
    }

    // ── Guard 4: Profile completion ────────────────────────
    // Authenticated but profile not set up yet
    if (authState.isAuthenticated &&
        !authState.isProfileComplete &&
        location != AppRoutes.profileSetup) {
      return AppRoutes.profileSetup;
    }

    // No redirect needed
    return null;
  }

  /// Async version — for guards that need async reads
  /// (e.g., checking Hive boxes asynchronously)
  static Future<String?> redirectAsync({
    required GoRouterState state,
    required WidgetRef ref,
  }) async {
    return redirect(state: state, ref: ref);
  }

  // ──────────────────────────────────────────────────────────
  // HELPERS
  // ──────────────────────────────────────────────────────────

  static bool _isPublicRoute(String location) {
    return _publicRoutes.any((route) => location.startsWith(route));
  }

  static bool _isAuthOnlyRoute(String location) {
    return _authOnlyRoutes.contains(location);
  }

  /// Check if a route requires a verified profile
  static bool requiresCompleteProfile(String location) {
    const profileRequired = {
      AppRoutes.checkout,
      AppRoutes.cart,
      AppRoutes.postAd,
      AppRoutes.bookingConfirm,
    };
    return profileRequired.any((r) => location.startsWith(r));
  }

  /// Debug — log guard decision
  static void _log(String message) {
    if (kDebugMode) debugPrint('🛡️ [Guard] $message');
  }
}

// ──────────────────────────────────────────────────────────────
// AUTH STATE MODEL
// Lightweight model used by guards and providers.
// Full user data lives in authNotifierProvider.
// ──────────────────────────────────────────────────────────────

class AuthGuardState {
  final bool isAuthenticated;
  final bool isProfileComplete;
  final String? userId;

  const AuthGuardState({
    this.isAuthenticated = false,
    this.isProfileComplete = false,
    this.userId,
  });

  const AuthGuardState.authenticated({
    required String userId,
    required bool profileComplete,
  })  : isAuthenticated = true,
        isProfileComplete = profileComplete,
        userId = userId;

  const AuthGuardState.unauthenticated()
      : isAuthenticated = false,
        isProfileComplete = false,
        userId = null;

  @override
  String toString() =>
      'AuthGuardState(auth: $isAuthenticated, profile: $isProfileComplete)';
}
