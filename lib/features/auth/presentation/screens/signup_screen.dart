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

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _accepted = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_accepted) return;
    HapticFeedback.selectionClick();
    setState(() => _loading = true);
    try {
      await ref.read(authStateProvider.notifier).signUp(
            name: _nameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            password: _passwordCtrl.text,
          );
      if (mounted) context.go(AppRoutes.dashboard);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        title: Text(isArabic ? 'إنشاء حساب' : 'Create Account'),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.card),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          children: [
            Text(
              isArabic ? 'ابدأ تجربتك مع كيان' : 'Start your KAYAN experience',
              style: isArabic
                  ? AppTextStyles.arabicHeadlineSmall
                  : AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 18),
            _Field(
              controller: _nameCtrl,
              label: isArabic ? 'الاسم الكامل' : 'Full name',
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 12),
            _Field(
              controller: _emailCtrl,
              label: isArabic ? 'البريد الإلكتروني' : 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _Field(
              controller: _phoneCtrl,
              label: isArabic ? 'رقم الجوال' : 'Phone',
              icon: Icons.phone_iphone_rounded,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _Field(
              controller: _passwordCtrl,
              label: isArabic ? 'كلمة المرور' : 'Password',
              icon: Icons.lock_outline_rounded,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: _accepted,
              onChanged: (value) => setState(() => _accepted = value ?? false),
              contentPadding: EdgeInsets.zero,
              title: Text(
                isArabic
                    ? 'أوافق على الشروط والأحكام وسياسة الخصوصية'
                    : 'I agree to the terms and privacy policy',
                style: AppTextStyles.bodySmall,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _accepted && !_loading ? _submit : null,
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isArabic ? 'تسجيل' : 'Sign Up'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go(AppRoutes.login),
              child: Text(isArabic ? 'لديك حساب؟ سجل الدخول' : 'Have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
