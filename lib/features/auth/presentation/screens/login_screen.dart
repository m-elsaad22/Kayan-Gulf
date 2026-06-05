// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/providers/locale_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _loading = false;
  int _tabIndex = 0;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    HapticFeedback.selectionClick();
    setState(() => _loading = true);
    try {
      await action();
      if (mounted) context.go(AppRoutes.dashboard);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(isArabicProvider);
    final auth = ref.read(authStateProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.hero),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: isArabic ? Alignment.topLeft : Alignment.topRight,
                  child: TextButton(
                    onPressed: _loading
                        ? null
                        : () => _run(() => auth.continueAsGuest()),
                    child: Text(
                      isArabic ? 'تخطي' : 'Skip',
                      style: AppTextStyles.buttonMedium.copyWith(
                        color: AppColors.metallicGold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  isArabic ? 'كيان' : 'KAYAN',
                  style: AppTextStyles.displaySmall.copyWith(
                    color: AppColors.metallicGold,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  isArabic
                      ? 'ادخل إلى خدماتك ومتجرك وإعلاناتك من مكان واحد'
                      : 'Access services, shopping, and classifieds in one place',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                _AuthTabs(
                  index: _tabIndex,
                  isArabic: isArabic,
                  onChanged: (index) => setState(() => _tabIndex = index),
                ),
                const SizedBox(height: 18),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: _tabIndex == 0
                      ? _EmailLoginForm(
                          key: const ValueKey('email'),
                          emailCtrl: _emailCtrl,
                          passwordCtrl: _passwordCtrl,
                          isArabic: isArabic,
                        )
                      : _PhoneLoginForm(
                          key: const ValueKey('phone'),
                          phoneCtrl: _phoneCtrl,
                          isArabic: isArabic,
                        ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                    child: Text(isArabic ? 'نسيت كلمة المرور؟' : 'Forgot password?'),
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () => _tabIndex == 0
                          ? _run(() => auth.loginWithEmail(
                                _emailCtrl.text.trim(),
                                _passwordCtrl.text,
                              ))
                          : context.push(AppRoutes.otpVerify, extra: _phoneCtrl.text.trim()),
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isArabic ? 'تسجيل الدخول' : 'Login'),
                ),
                const SizedBox(height: 22),
                _DividerLabel(label: isArabic ? 'أو' : 'OR'),
                const SizedBox(height: 16),
                _SocialButton(
                  label: 'Google',
                  icon: Icons.g_mobiledata_rounded,
                  onTap: () => _run(() => auth.loginWithGoogle()),
                ),
                const SizedBox(height: 10),
                _SocialButton(
                  label: 'Apple',
                  icon: Icons.apple_rounded,
                  onTap: () => _run(() => auth.loginWithApple()),
                ),
                const SizedBox(height: 10),
                _SocialButton(
                  label: 'Facebook',
                  icon: Icons.facebook_rounded,
                  onTap: () => _run(() => auth.loginWithFacebook()),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => context.push(AppRoutes.signup),
                  child: Text(
                    isArabic
                        ? 'ليس لديك حساب؟ سجل الآن'
                        : 'No account? Sign up',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthTabs extends StatelessWidget {
  final int index;
  final bool isArabic;
  final ValueChanged<int> onChanged;

  const _AuthTabs({
    required this.index,
    required this.isArabic,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final labels = [
      isArabic ? 'بريد إلكتروني' : 'Email',
      isArabic ? 'رقم الجوال' : 'Phone',
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppBorderRadius.pill,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = index == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: selected ? AppGradients.primaryButton : null,
                  borderRadius: AppBorderRadius.pill,
                ),
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: selected ? AppColors.textPrimary : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _EmailLoginForm extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final bool isArabic;

  const _EmailLoginForm({
    super.key,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: isArabic ? 'البريد الإلكتروني' : 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: passwordCtrl,
          obscureText: true,
          decoration: InputDecoration(
            labelText: isArabic ? 'كلمة المرور' : 'Password',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
          ),
        ),
      ],
    );
  }
}

class _PhoneLoginForm extends StatelessWidget {
  final TextEditingController phoneCtrl;
  final bool isArabic;

  const _PhoneLoginForm({
    super.key,
    required this.phoneCtrl,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: phoneCtrl,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: isArabic ? 'رقم الجوال' : 'Phone number',
        prefixIcon: const Icon(Icons.phone_iphone_rounded),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class _DividerLabel extends StatelessWidget {
  final String label;
  const _DividerLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label, style: AppTextStyles.caption),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
