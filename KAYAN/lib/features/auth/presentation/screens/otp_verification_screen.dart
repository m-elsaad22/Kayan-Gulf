// ============================================================
// KAYAN Super App — OTP Verification Screen
// lib/features/auth/presentation/screens/otp_verification_screen.dart
//
// Features:
//   • 6 individual digit boxes (custom, no library)
//   • Auto-advance on digit entry, auto-backspace on delete
//   • Paste support (pastes 6 digits at once)
//   • 60-second countdown → resend OTP button
//   • Shake animation on wrong code
//   • Green flash + forward navigation on success
//   • Error banner with Arabic / English messages
//   • Royal Metallic KAYAN design
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../providers/auth_providers.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phone;
  const OtpVerificationScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState
    extends ConsumerState<OtpVerificationScreen>
    with TickerProviderStateMixin {

  // ── OTP state ──────────────────────────────────────────────
  static const int _otpLength = 6;
  final List<String> _digits = List.filled(_otpLength, '');
  final List<FocusNode> _focuses =
      List.generate(_otpLength, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(_otpLength, (_) => TextEditingController());

  // ── Timer ─────────────────────────────────────────────────
  Timer? _timer;
  int _countdown = 60;

  // ── Animations ─────────────────────────────────────────────
  late final AnimationController _shakeCtrl;
  late final AnimationController _successCtrl;
  late final Animation<double> _shakeAnim;
  late final Animation<double> _successScale;
  late final Animation<Color?> _successColor;

  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();

    // Shake for wrong OTP
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12, end: 12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12, end: -8),  weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8),   weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: 0),    weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));

    // Success scale pop
    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _successScale = Tween<double>(begin: 0.85, end: 1.0)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_successCtrl);
    _successColor = ColorTween(
      begin: AppColors.bgCard,
      end:   AppColors.successBg,
    ).animate(_successCtrl);

    // Start countdown
    _startTimer();

    // Auto-focus first box
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focuses[0].requestFocus();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _countdown = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown <= 0) {
        t.cancel();
      } else {
        if (mounted) setState(() => _countdown--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeCtrl.dispose();
    _successCtrl.dispose();
    for (final n in _focuses)      n.dispose();
    for (final c in _controllers)  c.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────
  // DIGIT INPUT LOGIC
  // ──────────────────────────────────────────────────────────

  void _onDigitChanged(int index, String value) {
    // Handle paste (6 chars at once)
    if (value.length > 1) {
      final clean = value.replaceAll(RegExp(r'\D'), '');
      if (clean.length == _otpLength) {
        _pasteSixDigits(clean);
        return;
      }
    }

    final digit = value.replaceAll(RegExp(r'\D'), '');
    if (digit.isEmpty) return; // handled by _onKeyEvent

    setState(() => _digits[index] = digit.isNotEmpty ? digit[0] : '');
    _controllers[index].text = _digits[index];
    _controllers[index].selection = TextSelection.fromPosition(
      TextPosition(offset: _controllers[index].text.length),
    );

    // Move to next
    if (digit.isNotEmpty && index < _otpLength - 1) {
      _focuses[index + 1].requestFocus();
    }

    // Auto-submit when all filled
    if (_digits.every((d) => d.isNotEmpty)) {
      _verifyOtp();
    }
  }

  void _onKeyEvent(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_digits[index].isNotEmpty) {
        setState(() => _digits[index] = '');
        _controllers[index].clear();
      } else if (index > 0) {
        setState(() => _digits[index - 1] = '');
        _controllers[index - 1].clear();
        _focuses[index - 1].requestFocus();
      }
    }
  }

  void _pasteSixDigits(String six) {
    for (int i = 0; i < _otpLength; i++) {
      setState(() => _digits[i] = six[i]);
      _controllers[i].text = six[i];
    }
    _focuses[_otpLength - 1].requestFocus();
    _verifyOtp();
  }

  // ──────────────────────────────────────────────────────────
  // VERIFY
  // ──────────────────────────────────────────────────────────

  Future<void> _verifyOtp() async {
    final code = _digits.join();
    if (code.length < _otpLength) return;

    FocusScope.of(context).unfocus();
    final notifier = ref.read(verifyOtpProvider.notifier);
    final success  = await notifier.verifyOtp(widget.phone, code);

    if (!mounted) return;

    if (success) {
      // Trigger success animation, then navigate
      setState(() => _showSuccess = true);
      await _successCtrl.forward();
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 400));

      final authState = ref.read(authStateProvider);
      if (mounted) {
        context.go(authState.isProfileComplete
            ? AppRoutes.home
            : AppRoutes.profileSetup);
      }
    } else {
      // Shake + clear
      HapticFeedback.vibrate();
      _shakeCtrl.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 300));
      _clearOtp();
    }
  }

  void _clearOtp() {
    setState(() {
      for (int i = 0; i < _otpLength; i++) {
        _digits[i] = '';
        _controllers[i].clear();
      }
    });
    _focuses[0].requestFocus();
  }

  // Resend OTP
  Future<void> _resend() async {
    if (_countdown > 0) return;
    final notifier = ref.read(sendOtpProvider.notifier);
    final success  = await notifier.sendOtp(widget.phone);
    if (success && mounted) _startTimer();
  }

  // ──────────────────────────────────────────────────────────
  // BUILD
  // ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isArabic  = ref.watch(isArabicProvider);
    final verifyState = ref.watch(verifyOtpProvider);
    final isLoading   = verifyState.isLoading;
    final error       = verifyState.error;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgScaffold,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation:       0,
          leading: IconButton(
            icon: Icon(
              isArabic
                  ? Icons.arrow_forward_ios_rounded
                  : Icons.arrow_back_ios_new_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── Headline ──────────────────────────────────
              Text(
                isArabic ? 'رمز التحقق' : 'Verification Code',
                style: isArabic
                    ? AppTextStyles.arabicHeadlineMedium
                    : AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: isArabic
                      ? AppTextStyles.arabicBodyMedium.copyWith(
                          color: AppColors.textSecondary)
                      : AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary),
                  children: [
                    TextSpan(
                      text: isArabic
                          ? 'تم إرسال رمز مكون من 6 أرقام إلى '
                          : 'We sent a 6-digit code to ',
                    ),
                    TextSpan(
                      text: widget.phone,
                      style: const TextStyle(
                        color:      AppColors.skyBlue,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // ── 6 OTP Boxes ───────────────────────────────
              AnimatedBuilder(
                animation: _shakeAnim,
                builder: (_, child) => Transform.translate(
                  offset: Offset(_shakeAnim.value, 0),
                  child:  child,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    _otpLength,
                    (i) => _OtpBox(
                      index:      i,
                      digit:      _digits[i],
                      controller: _controllers[i],
                      focusNode:  _focuses[i],
                      isLoading:  isLoading,
                      showSuccess: _showSuccess,
                      hasError:   error != null,
                      onChanged:  (v) => _onDigitChanged(i, v),
                      onKey:      (e) => _onKeyEvent(i, e),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Error banner ──────────────────────────────
              if (error != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical:   AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color:        AppColors.errorBg,
                    borderRadius: AppBorderRadius.sm,
                    border:       Border.all(
                        color: AppColors.borderError, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          size: 16, color: AppColors.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          error,
                          style: (isArabic
                                  ? AppTextStyles.arabicCaption
                                  : AppTextStyles.bodySmall)
                              .copyWith(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),

              // ── Resend ────────────────────────────────────
              Center(
                child: _countdown > 0
                    ? RichText(
                        text: TextSpan(
                          style: isArabic
                              ? AppTextStyles.arabicBodyMedium.copyWith(
                                  color: AppColors.textSecondary)
                              : AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary),
                          children: [
                            TextSpan(
                              text: isArabic
                                  ? 'إعادة الإرسال خلال '
                                  : 'Resend in ',
                            ),
                            TextSpan(
                              text: '${_countdown}s',
                              style: const TextStyle(
                                color: AppColors.metallicGold,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: _resend,
                        child: Text(
                          isArabic ? 'إعادة إرسال الرمز' : 'Resend Code',
                          style: (isArabic
                                  ? AppTextStyles.arabicBodyMedium
                                  : AppTextStyles.bodyMedium)
                              .copyWith(
                            color:      AppColors.skyBlue,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.skyBlue,
                          ),
                        ),
                      ),
              ),

              const Spacer(),

              // ── Verify button ─────────────────────────────
              _VerifyButton(
                isEnabled:   _digits.every((d) => d.isNotEmpty) && !isLoading,
                isLoading:   isLoading,
                showSuccess: _showSuccess,
                isArabic:    isArabic,
                onTap:       _verifyOtp,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// OTP BOX WIDGET
// ──────────────────────────────────────────────────────────────
class _OtpBox extends StatefulWidget {
  final int                       index;
  final String                    digit;
  final TextEditingController     controller;
  final FocusNode                 focusNode;
  final bool                      isLoading;
  final bool                      showSuccess;
  final bool                      hasError;
  final ValueChanged<String>      onChanged;
  final ValueChanged<RawKeyEvent> onKey;

  const _OtpBox({
    required this.index,
    required this.digit,
    required this.controller,
    required this.focusNode,
    required this.isLoading,
    required this.showSuccess,
    required this.hasError,
    required this.onChanged,
    required this.onKey,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (mounted) setState(() => _isFocused = widget.focusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasDigit = widget.digit.isNotEmpty;

    // Border color priority: error > success > focused > default
    final Color borderColor;
    if (widget.hasError && hasDigit) {
      borderColor = AppColors.borderError;
    } else if (widget.showSuccess) {
      borderColor = AppColors.borderSuccess;
    } else if (_isFocused) {
      borderColor = AppColors.borderActiveBold;
    } else if (hasDigit) {
      borderColor = AppColors.borderGold;
    } else {
      borderColor = AppColors.borderDefault;
    }

    // Background
    final Color bgColor = widget.showSuccess
        ? AppColors.successBg
        : widget.hasError && hasDigit
            ? AppColors.errorBg
            : _isFocused
                ? AppColors.royalBlue.withOpacity(0.06)
                : AppColors.bgInput;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width:  52,
      height: 60,
      decoration: BoxDecoration(
        color:        bgColor,
        borderRadius: AppBorderRadius.md,
        border:       Border.all(color: borderColor, width: 2),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color:      AppColors.royalBlue.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ]
            : [],
      ),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey:     widget.onKey,
        child: Center(
          child: widget.isLoading && hasDigit
              ? const SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(
                    color:       AppColors.royalBlue,
                    strokeWidth: 2,
                  ),
                )
              : EditableText(
                  controller:     widget.controller,
                  focusNode:      widget.focusNode,
                  style:          AppTextStyles.otpDigit.copyWith(
                    color: widget.showSuccess
                        ? AppColors.success
                        : widget.hasError && hasDigit
                            ? AppColors.error
                            : _isFocused
                                ? AppColors.textPrimary
                                : AppColors.metallicGold,
                  ),
                  cursorColor:    AppColors.royalBlue,
                  cursorWidth:    2,
                  showCursor:     _isFocused && !hasDigit,
                  backgroundCursorColor: Colors.transparent,
                  textAlign:      TextAlign.center,
                  keyboardType:   TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1),
                  ],
                  onChanged:      widget.onChanged,
                  autocorrect:    false,
                  enableSuggestions: false,
                ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// VERIFY BUTTON
// ──────────────────────────────────────────────────────────────
class _VerifyButton extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final bool showSuccess;
  final bool isArabic;
  final VoidCallback onTap;

  const _VerifyButton({
    required this.isEnabled,
    required this.isLoading,
    required this.showSuccess,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity:  isEnabled || showSuccess ? 1.0 : 0.45,
      child: GestureDetector(
        onTap: isEnabled && !isLoading ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height:   56,
          decoration: BoxDecoration(
            gradient: showSuccess
                ? const LinearGradient(
                    colors: [AppColors.success, AppColors.successDark],
                  )
                : isEnabled
                    ? AppGradients.primaryButton
                    : const LinearGradient(
                        colors: [AppColors.bgCard2, AppColors.bgCard2],
                      ),
            borderRadius: AppBorderRadius.button,
            boxShadow: (isEnabled || showSuccess) ? [
              BoxShadow(
                color: (showSuccess ? AppColors.success : AppColors.royalBlue)
                    .withOpacity(0.35),
                blurRadius: 20,
                offset:     const Offset(0, 6),
              ),
            ] : [],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24, height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                  )
                : showSuccess
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: Colors.white, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            isArabic ? 'تم التحقق ✓' : 'Verified ✓',
                            style: isArabic
                                ? AppTextStyles.arabicButton
                                : AppTextStyles.buttonMedium,
                          ),
                        ],
                      )
                    : Text(
                        isArabic ? 'تحقق' : 'Verify',
                        style: isArabic
                            ? AppTextStyles.arabicButton
                            : AppTextStyles.buttonMedium,
                      ),
          ),
        ),
      ),
    );
  }
}
