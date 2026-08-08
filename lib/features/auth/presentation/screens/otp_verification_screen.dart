import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../providers/auth_providers.dart';

/// التحقق من OTP — light design
class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key, required this.phone});

  final String phone;

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  Timer? _timer;
  int _countdown = 60;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _countdown = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown <= 0) {
        t.cancel();
      } else if (mounted) {
        setState(() => _countdown--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _maskedPhone {
    final p = widget.phone;
    if (p.length < 6) return p;
    return '${p.substring(0, p.length - 4)}****';
  }

  Future<void> _verify(String code) async {
    HapticFeedback.selectionClick();
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await ref.read(verifyOtpProvider.notifier).verifyOtp(widget.phone, code);
    if (!mounted) return;
    if (result.success && result.userId != null) {
      ref.read(authStateProvider.notifier).setAuthenticated(
            userId: result.userId!,
            accessToken: result.accessToken ?? '',
            refreshToken: result.refreshToken ?? '',
            isProfileComplete: result.isProfileComplete,
          );
      context.go(AppRoutes.profileSetup);
    } else {
      final err = ref.read(verifyOtpProvider).error;
      setState(() {
        _loading = false;
        _error = err ?? (ref.read(isArabicProvider) ? 'رمز غير صحيح' : 'Invalid code');
      });
    }
  }

  Future<void> _resend() async {
    if (_countdown > 0) return;
    await ref.read(sendOtpProvider.notifier).sendOtp(widget.phone);
    _startTimer();
    if (mounted) {
      final ar = ref.read(isArabicProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ar ? 'تم إرسال رمز جديد' : 'New code sent')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    final pinTheme = PinTheme(
      width: 48,
      height: 52,
      textStyle: KayanDesignTokens.cairo(fontSize: 20, fontWeight: FontWeight.w800),
      decoration: BoxDecoration(
        color: KayanDesignTokens.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KayanDesignTokens.border),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'رمز التحقق' : 'Verification code', onBack: () => context.pop()),
              const SizedBox(height: 20),
              Text(
                ar ? 'أدخل الرمز المرسل إلى' : 'Enter the code sent to',
                textAlign: TextAlign.center,
                style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2),
              ),
              const SizedBox(height: 4),
              Text(
                _maskedPhone,
                textAlign: TextAlign.center,
                style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep),
              ),
              const SizedBox(height: 28),
              Pinput(
                length: 6,
                enabled: !_loading,
                defaultPinTheme: pinTheme,
                focusedPinTheme: pinTheme.copyWith(
                  decoration: pinTheme.decoration!.copyWith(
                    border: Border.all(color: KayanDesignTokens.kBlue, width: 1.5),
                  ),
                ),
                onCompleted: _verify,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, textAlign: TextAlign.center, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.danger)),
              ],
              const SizedBox(height: 16),
              Text(
                _countdown > 0
                    ? (ar ? 'إعادة الإرسال خلال $_countdown ث' : 'Resend in $_countdown s')
                    : (ar ? 'يمكنك إعادة إرسال الرمز' : 'You can resend the code'),
                textAlign: TextAlign.center,
                style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.muted),
              ),
              const Spacer(),
              if (_loading)
                const Center(child: CircularProgressIndicator())
              else
                KayanCtaButton(
                  label: ar ? 'إعادة إرسال الرمز' : 'Resend code',
                  trailingIcon: Icons.refresh_rounded,
                  variant: KayanCtaVariant.blue,
                  onPressed: _countdown > 0 ? null : _resend,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
