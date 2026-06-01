// ============================================================
// KAYAN Super App — Phone Input Screen
// lib/features/auth/presentation/screens/phone_input_screen.dart
//
// Features:
//   • Country code picker (Gulf countries first)
//   • Phone number validation (per country)
//   • Keyboard dismiss on tap outside
//   • Auto-focus on mount
//   • Riverpod state: loading / error feedback
//   • Fully bilingual (AR / EN)
//   • KAYAN Royal Metallic luxury design
// ============================================================

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
import '../../../../shared/providers/locale_provider.dart';
import '../providers/auth_providers.dart';

// ──────────────────────────────────────────────────────────────
// COUNTRY MODEL
// ──────────────────────────────────────────────────────────────

class _Country {
  final String code;     // +966
  final String isoCode;  // SA
  final String flag;     // 🇸🇦
  final String name;
  final String nameAr;
  final int    maxLength;

  const _Country({
    required this.code,
    required this.isoCode,
    required this.flag,
    required this.name,
    required this.nameAr,
    required this.maxLength,
  });
}

const List<_Country> _countries = [
  _Country(code: '+966', isoCode: 'SA', flag: '🇸🇦', name: 'Saudi Arabia',   nameAr: 'المملكة العربية السعودية', maxLength: 9),
  _Country(code: '+971', isoCode: 'AE', flag: '🇦🇪', name: 'UAE',            nameAr: 'الإمارات العربية المتحدة',  maxLength: 9),
  _Country(code: '+974', isoCode: 'QA', flag: '🇶🇦', name: 'Qatar',          nameAr: 'قطر',                       maxLength: 8),
  _Country(code: '+965', isoCode: 'KW', flag: '🇰🇼', name: 'Kuwait',         nameAr: 'الكويت',                    maxLength: 8),
  _Country(code: '+973', isoCode: 'BH', flag: '🇧🇭', name: 'Bahrain',        nameAr: 'البحرين',                   maxLength: 8),
  _Country(code: '+968', isoCode: 'OM', flag: '🇴🇲', name: 'Oman',           nameAr: 'عُمان',                     maxLength: 8),
  _Country(code: '+20',  isoCode: 'EG', flag: '🇪🇬', name: 'Egypt',          nameAr: 'مصر',                       maxLength: 10),
  _Country(code: '+962', isoCode: 'JO', flag: '🇯🇴', name: 'Jordan',         nameAr: 'الأردن',                    maxLength: 9),
  _Country(code: '+961', isoCode: 'LB', flag: '🇱🇧', name: 'Lebanon',        nameAr: 'لبنان',                     maxLength: 8),
  _Country(code: '+1',   isoCode: 'US', flag: '🇺🇸', name: 'United States',  nameAr: 'الولايات المتحدة',          maxLength: 10),
  _Country(code: '+44',  isoCode: 'GB', flag: '🇬🇧', name: 'United Kingdom', nameAr: 'المملكة المتحدة',           maxLength: 10),
];

// ──────────────────────────────────────────────────────────────
// SCREEN
// ──────────────────────────────────────────────────────────────

class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen>
    with SingleTickerProviderStateMixin {

  final _phoneCtrl  = TextEditingController();
  final _focusNode  = FocusNode();
  final _formKey    = GlobalKey<FormState>();

  _Country _selected  = _countries.first; // Default: Saudi Arabia
  bool     _isValid   = false;

  // Shake animation for error
  late final AnimationController _shakeCtrl;
  late final Animation<double>   _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));
    _shakeAnim = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_shakeCtrl);

    // Auto-focus after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    _phoneCtrl.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    final digits = _phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
    setState(() {
      _isValid = digits.length >= 8 && digits.length <= _selected.maxLength;
    });
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _focusNode.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────
  // SEND OTP
  // ──────────────────────────────────────────────────────────
  Future<void> _sendOtp() async {
    FocusScope.of(context).unfocus();
    if (!_isValid) {
      _shakeCtrl.forward(from: 0);
      return;
    }

    final phone = '${_selected.code}${_phoneCtrl.text.trim()}';

    final notifier = ref.read(sendOtpProvider.notifier);
    final success  = await notifier.sendOtp(phone);

    if (mounted && success) {
      context.push(AppRoutes.otpVerify, extra: phone);
    } else if (mounted) {
      _shakeCtrl.forward(from: 0);
    }
  }

  // ──────────────────────────────────────────────────────────
  // COUNTRY PICKER
  // ──────────────────────────────────────────────────────────
  void _showCountryPicker() {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context:        context,
      isScrollControlled: true,
      builder: (_) => _CountryPickerSheet(
        selected: _selected,
        onSelect: (country) {
          setState(() => _selected = country);
          _onPhoneChanged();
        },
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // BUILD
  // ──────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isArabic  = ref.watch(isArabicProvider);
    final authState = ref.watch(sendOtpProvider);
    final isLoading = authState.isLoading;
    final error     = authState.error;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgScaffold,
        body: CustomScrollView(
          slivers: [
            // ── App Bar ────────────────────────────────────
            SliverAppBar(
              backgroundColor: Colors.transparent,
              floating: true,
              leading: Navigator.canPop(context)
                  ? IconButton(
                      icon: Icon(
                        isArabic
                            ? Icons.arrow_forward_ios_rounded
                            : Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () => context.pop(),
                    )
                  : null,
            ),

            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePadding,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // ── Logo ──────────────────────────────
                      Center(
                        child: Container(
                          width: 64, height: 64,
                          decoration: BoxDecoration(
                            gradient:     AppGradients.primaryButton,
                            borderRadius: BorderRadius.circular(18),
                            border:       Border.all(
                              color: AppColors.borderGold, width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:      AppColors.royalBlue.withOpacity(0.3),
                                blurRadius: 20,
                                offset:     const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text('K',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize:   32,
                                fontWeight: FontWeight.w800,
                                color:      Colors.white,
                                height:     1,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 36),

                      // ── Headline ──────────────────────────
                      Text(
                        isArabic ? 'أدخل رقم هاتفك' : 'Enter your phone',
                        style: isArabic
                            ? AppTextStyles.arabicHeadlineMedium
                            : AppTextStyles.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isArabic
                            ? 'سنرسل لك رمز تحقق مكون من 6 أرقام'
                            : 'We\'ll send you a 6-digit verification code',
                        style: isArabic
                            ? AppTextStyles.arabicBodyMedium.copyWith(
                                color: AppColors.textSecondary)
                            : AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary),
                      ),

                      const SizedBox(height: 40),

                      // ── Phone input ───────────────────────
                      AnimatedBuilder(
                        animation: _shakeAnim,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(
                            math_sin(_shakeAnim.value * 3 * 3.14159) * 8,
                            0,
                          ),
                          child: child,
                        ),
                        child: _PhoneInputField(
                          controller: _phoneCtrl,
                          focusNode:  _focusNode,
                          country:    _selected,
                          isArabic:   isArabic,
                          maxLength:  _selected.maxLength,
                          onCountryTap: _showCountryPicker,
                        ),
                      ),

                      // ── Error message ─────────────────────
                      if (error != null) ...[
                        const SizedBox(height: 12),
                        _ErrorBanner(message: error, isArabic: isArabic),
                      ],

                      const SizedBox(height: 12),

                      // ── Privacy note ──────────────────────
                      _PrivacyNote(isArabic: isArabic),

                      const Spacer(),

                      // ── Send OTP button ───────────────────
                      _SendOtpButton(
                        isEnabled: _isValid,
                        isLoading: isLoading,
                        isArabic:  isArabic,
                        onTap:     _sendOtp,
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// math.sin workaround (no import needed since we use dart:math)
double math_sin(double x) {
  // Simple sin approximation for shake
  return _dartSin(x);
}

double _dartSin(double x) {
  // Use built-in via dart:math indirectly
  final v = x % (2 * 3.14159265);
  // Taylor series approximation
  return v - (v * v * v / 6) + (v * v * v * v * v / 120);
}

// ──────────────────────────────────────────────────────────────
// PHONE INPUT FIELD
// ──────────────────────────────────────────────────────────────
class _PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final _Country  country;
  final bool      isArabic;
  final int       maxLength;
  final VoidCallback onCountryTap;

  const _PhoneInputField({
    required this.controller,
    required this.focusNode,
    required this.country,
    required this.isArabic,
    required this.maxLength,
    required this.onCountryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:        AppColors.bgInput,
        borderRadius: AppBorderRadius.input,
        border:       Border.all(color: AppColors.borderDefault, width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          textDirection: TextDirection.ltr, // Always LTR for phone
          children: [
            // Country selector
            GestureDetector(
              onTap:    onCountryTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: AppColors.borderSubtle, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(country.flag,
                        style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 6),
                    Text(
                      country.code,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 18, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),

            // Phone number field
            Expanded(
              child: TextFormField(
                controller:     controller,
                focusNode:      focusNode,
                textDirection:  TextDirection.ltr,
                textAlign:      TextAlign.left,
                keyboardType:   TextInputType.phone,
                maxLength:      maxLength,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style:          AppTextStyles.titleMedium.copyWith(
                  letterSpacing: 2,
                ),
                decoration: InputDecoration(
                  hintText: isArabic
                      ? 'رقم الهاتف'
                      : 'Phone number',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color:         AppColors.textMuted,
                    letterSpacing: 0,
                  ),
                  border:        InputBorder.none,
                  counterText:   '',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                  filled: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// SEND OTP BUTTON
// ──────────────────────────────────────────────────────────────
class _SendOtpButton extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final bool isArabic;
  final VoidCallback onTap;

  const _SendOtpButton({
    required this.isEnabled,
    required this.isLoading,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity:  isEnabled ? 1.0 : 0.4,
      child: GestureDetector(
        onTap: isEnabled && !isLoading ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height:   56,
          decoration: BoxDecoration(
            gradient: isEnabled
                ? AppGradients.primaryButton
                : const LinearGradient(
                    colors: [AppColors.bgCard2, AppColors.bgCard2],
                  ),
            borderRadius: AppBorderRadius.button,
            boxShadow: isEnabled ? [
              BoxShadow(
                color:      AppColors.royalBlue.withOpacity(0.4),
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
                      color:       Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isArabic ? 'إرسال رمز التحقق' : 'Send Verification Code',
                        style: isArabic
                            ? AppTextStyles.arabicButton
                            : AppTextStyles.buttonMedium,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isArabic
                            ? Icons.arrow_back_ios_new_rounded
                            : Icons.arrow_forward_ios_rounded,
                        size:  16,
                        color: Colors.white,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// ERROR BANNER
// ──────────────────────────────────────────────────────────────
class _ErrorBanner extends StatelessWidget {
  final String message;
  final bool   isArabic;
  const _ErrorBanner({required this.message, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical:   AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color:        AppColors.errorBg,
        borderRadius: AppBorderRadius.sm,
        border:       Border.all(color: AppColors.borderError, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 16, color: AppColors.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: (isArabic
                      ? AppTextStyles.arabicCaption
                      : AppTextStyles.bodySmall)
                  .copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// PRIVACY NOTE
// ──────────────────────────────────────────────────────────────
class _PrivacyNote extends StatelessWidget {
  final bool isArabic;
  const _PrivacyNote({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Text(
      isArabic
          ? 'بالمتابعة، أنت توافق على شروط الاستخدام وسياسة الخصوصية'
          : 'By continuing, you agree to our Terms of Service and Privacy Policy',
      style: (isArabic
              ? AppTextStyles.arabicCaption
              : AppTextStyles.caption)
          .copyWith(color: AppColors.textDisabled),
      textAlign: TextAlign.center,
    );
  }
}

// ──────────────────────────────────────────────────────────────
// COUNTRY PICKER BOTTOM SHEET
// ──────────────────────────────────────────────────────────────
class _CountryPickerSheet extends ConsumerWidget {
  final _Country selected;
  final void Function(_Country) onSelect;

  const _CountryPickerSheet({
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(isArabicProvider);

    return DraggableScrollableSheet(
      expand:           false,
      initialChildSize: 0.6,
      maxChildSize:     0.85,
      minChildSize:     0.4,
      builder: (context, scroll) => Container(
        decoration: BoxDecoration(
          color:        AppColors.bgBottomSheet,
          borderRadius: AppBorderRadius.bottomSheet,
        ),
        child: Column(
          children: [
            // Handle
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color:        AppColors.borderDefault,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
              ),
              child: Align(
                alignment: isArabic
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  isArabic ? 'اختر الدولة' : 'Select Country',
                  style: isArabic
                      ? AppTextStyles.arabicTitleMedium
                      : AppTextStyles.titleMedium,
                ),
              ),
            ),
            const SizedBox(height: 8),

            const Divider(height: 1, color: AppColors.borderSubtle),

            // Country list
            Expanded(
              child: ListView.builder(
                controller:   scroll,
                itemCount:    _countries.length,
                itemBuilder:  (_, i) {
                  final country   = _countries[i];
                  final isActive  = country.isoCode == selected.isoCode;

                  return InkWell(
                    onTap: () {
                      onSelect(country);
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: isActive
                          ? AppColors.royalBlue.withOpacity(0.08)
                          : Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical:   14,
                      ),
                      child: Row(
                        children: [
                          Text(country.flag,
                              style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              isArabic ? country.nameAr : country.name,
                              style: (isArabic
                                      ? AppTextStyles.arabicBodyMedium
                                      : AppTextStyles.bodyMedium)
                                  .copyWith(
                                    color: isActive
                                        ? AppColors.skyBlue
                                        : AppColors.textPrimary,
                                  ),
                            ),
                          ),
                          Text(
                            country.code,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                          if (isActive) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.check_circle_rounded,
                                size: 18, color: AppColors.royalBlue),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
