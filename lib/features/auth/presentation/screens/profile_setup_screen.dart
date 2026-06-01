// ============================================================
// KAYAN Super App — Profile Setup Screen
// lib/features/auth/presentation/screens/profile_setup_screen.dart
//
// Shown once after first OTP verification.
// Fields: First name, Last name, optional avatar upload.
// Bilingual (AR/EN), gold CTA, avatar picker.
// ============================================================

import 'package:flutter/material.dart';
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

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _firstCtrl = TextEditingController();
  final _lastCtrl  = TextEditingController();
  bool  _isLoading = false;

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // TODO: API call

    ref.read(authStateProvider.notifier).markProfileComplete();

    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(isArabicProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgScaffold,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // ── Avatar picker ──────────────────────────
                  Stack(
                    children: [
                      Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          shape:   BoxShape.circle,
                          gradient: AppGradients.card,
                          border:   Border.all(
                            color: AppColors.borderGold, width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size:  52,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          width: 30, height: 30,
                          decoration: BoxDecoration(
                            shape:    BoxShape.circle,
                            gradient: AppGradients.goldButton,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 16, color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // ── Headline ──────────────────────────────
                  Align(
                    alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                    child: Text(
                      isArabic ? 'أكمل ملفك الشخصي' : 'Complete your profile',
                      style: isArabic
                          ? AppTextStyles.arabicHeadlineSmall
                          : AppTextStyles.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                    child: Text(
                      isArabic
                          ? 'يمكنك تعديل هذه البيانات لاحقاً من الملف الشخصي'
                          : 'You can update this anytime from your profile',
                      style: (isArabic
                              ? AppTextStyles.arabicBodySmall
                              : AppTextStyles.bodySmall)
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── First name ────────────────────────────
                  _KayanField(
                    controller: _firstCtrl,
                    label:      isArabic ? 'الاسم الأول' : 'First Name',
                    hint:       isArabic ? 'مثال: محمد' : 'e.g. Mohammed',
                    isArabic:   isArabic,
                    validator:  (v) => (v == null || v.trim().isEmpty)
                        ? (isArabic ? 'مطلوب' : 'Required')
                        : null,
                  ),

                  const SizedBox(height: 16),

                  // ── Last name ─────────────────────────────
                  _KayanField(
                    controller: _lastCtrl,
                    label:      isArabic ? 'اسم العائلة' : 'Last Name',
                    hint:       isArabic ? 'مثال: العمري' : 'e.g. Al-Omari',
                    isArabic:   isArabic,
                    validator:  (v) => (v == null || v.trim().isEmpty)
                        ? (isArabic ? 'مطلوب' : 'Required')
                        : null,
                  ),

                  const SizedBox(height: 48),

                  // ── Complete button ───────────────────────
                  GestureDetector(
                    onTap: _isLoading ? null : _complete,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient:     AppGradients.goldButton,
                        borderRadius: AppBorderRadius.button,
                        boxShadow: [
                          BoxShadow(
                            color:      AppColors.metallicGold.withOpacity(0.35),
                            blurRadius: 20,
                            offset:     const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _isLoading
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
                                    isArabic ? 'ابدأ التسوق في كيان' : 'Start Shopping on KAYAN',
                                    style: (isArabic
                                            ? AppTextStyles.arabicButton
                                            : AppTextStyles.buttonMedium)
                                        .copyWith(color: AppColors.bgPrimary),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    isArabic
                                        ? Icons.arrow_back_ios_new_rounded
                                        : Icons.arrow_forward_ios_rounded,
                                    size:  16,
                                    color: AppColors.bgPrimary,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Skip for now
                  TextButton(
                    onPressed: () {
                      ref.read(authStateProvider.notifier).markProfileComplete();
                      context.go(AppRoutes.home);
                    },
                    child: Text(
                      isArabic ? 'تخطي الآن' : 'Skip for now',
                      style: (isArabic
                              ? AppTextStyles.arabicBodyMedium
                              : AppTextStyles.bodyMedium)
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KayanField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool   isArabic;
  final String? Function(String?) validator;

  const _KayanField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.isArabic,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:     controller,
      textDirection:  isArabic ? TextDirection.rtl : TextDirection.ltr,
      style:          isArabic
          ? AppTextStyles.arabicBodyMedium
          : AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText:  hint,
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
