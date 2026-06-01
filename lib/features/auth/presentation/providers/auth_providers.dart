// ============================================================
// KAYAN — Auth Feature Providers
// lib/features/auth/presentation/providers/auth_providers.dart
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ──────────────────────────────────────────────────────────────
// OTP STATE
// ──────────────────────────────────────────────────────────────

class OtpState {
  final bool    isLoading;
  final String? error;
  final bool    success;
  final int     resendCountdown; // seconds

  const OtpState({
    this.isLoading        = false,
    this.error,
    this.success          = false,
    this.resendCountdown  = 0,
  });

  OtpState copyWith({
    bool?    isLoading,
    String?  error,
    bool?    success,
    int?     resendCountdown,
  }) => OtpState(
    isLoading:       isLoading       ?? this.isLoading,
    error:           error,           // null clears error
    success:         success          ?? this.success,
    resendCountdown: resendCountdown  ?? this.resendCountdown,
  );
}

// ──────────────────────────────────────────────────────────────
// SEND OTP NOTIFIER
// ──────────────────────────────────────────────────────────────

class SendOtpNotifier extends AutoDisposeNotifier<OtpState> {
  @override
  OtpState build() => const OtpState();

  Future<bool> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true);
    try {
      // TODO: inject AuthRepository and call sendOtp(phone)
      // final repo = ref.read(authRepositoryProvider);
      // await repo.sendOtp(phone);
      await Future.delayed(const Duration(seconds: 1)); // Simulate
      state = state.copyWith(isLoading: false, success: true, resendCountdown: 60);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _parseError(e),
      );
      return false;
    }
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('too_many')) return 'تجاوزت الحد المسموح. حاول لاحقاً';
    if (msg.contains('invalid'))  return 'رقم الهاتف غير صحيح';
    return 'حدث خطأ. يرجى المحاولة مجدداً';
  }
}

final sendOtpProvider =
    AutoDisposeNotifierProvider<SendOtpNotifier, OtpState>(SendOtpNotifier.new);

// ──────────────────────────────────────────────────────────────
// VERIFY OTP NOTIFIER
// ──────────────────────────────────────────────────────────────

class VerifyOtpNotifier extends AutoDisposeNotifier<OtpState> {
  @override
  OtpState build() => const OtpState();

  Future<bool> verifyOtp(String phone, String code) async {
    state = state.copyWith(isLoading: true);
    try {
      // TODO: inject AuthRepository
      // final result = await repo.verifyOtp(phone, code);
      await Future.delayed(const Duration(seconds: 1));

      // On success: update global auth state
      // ref.read(authStateProvider.notifier).setAuthenticated(...)

      state = state.copyWith(isLoading: false, success: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _parseError(e),
      );
      return false;
    }
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('invalid') || msg.contains('wrong')) {
      return 'رمز التحقق غير صحيح';
    }
    if (msg.contains('expired')) return 'انتهت صلاحية الرمز. أعد الإرسال';
    return 'حدث خطأ. يرجى المحاولة مجدداً';
  }
}

final verifyOtpProvider =
    AutoDisposeNotifierProvider<VerifyOtpNotifier, OtpState>(VerifyOtpNotifier.new);
