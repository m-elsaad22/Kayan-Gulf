// Login — matches design/html/08-login-1.html
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

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
  bool _remember = true;
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
    } catch (e) {
      if (mounted) {
        final ar = ref.read(isArabicProvider);
        final msg = _errorMessage(e.toString(), ar);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _errorMessage(String error, bool ar) {
    if (error.contains('user_not_found')) {
      return ar ? 'البريد الإلكتروني غير مسجل' : 'Email not registered';
    }
    if (error.contains('wrong_password')) {
      return ar ? 'كلمة المرور غير صحيحة' : 'Wrong password';
    }
    if (error.contains('invalid_email')) {
      return ar ? 'البريد الإلكتروني غير صالح' : 'Invalid email address';
    }
    if (error.contains('password_too_short')) {
      return ar ? 'كلمة المرور قصيرة جداً (6 أحرف على الأقل)' : 'Password too short (min 6 chars)';
    }
    if (error.contains('google_not_configured') ||
        error.contains('apple_not_configured') ||
        error.contains('facebook_not_configured')) {
      return ar ? 'هذا الخيار غير متاح حالياً' : 'This option is not available yet';
    }
    return ar ? 'حدث خطأ، يرجى المحاولة مجدداً' : 'An error occurred, please try again';
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final auth = ref.read(authStateProvider.notifier);

    return KayanEntryScaffold(
      smallHero: true,
      heroHeight: 220,
      hero: Stack(
        children: [
          Positioned(
            top: 8,
            left: 24,
            right: 24,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: _loading ? null : () => _run(() => auth.continueAsGuest()),
                child: Text(
                  ar ? 'تخطي' : 'Skip',
                  style: KayanDesignTokens.cairo(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.8)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Align(alignment: Alignment.center, child: KayanBrandLogo(size: 64)),
                const SizedBox(height: 14),
                KayanEntryTitle(before: ar ? 'تسجيل ' : 'Sign ', highlight: ar ? 'الدخول' : 'in'),
                const SizedBox(height: 8),
                KayanEntrySubtitle(ar ? 'أهلاً بعودتك، سجّل دخولك للمتابعة' : 'Welcome back, sign in to continue'),
              ],
            ),
          ),
        ],
      ),
      sheet: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AuthTabs(index: _tabIndex, isArabic: ar, onChanged: (i) => setState(() => _tabIndex = i)),
            const SizedBox(height: 18),
            if (_tabIndex == 0) ...[
              KayanDesignTextField(
                label: ar ? 'البريد الإلكتروني أو رقم الجوال' : 'Email or phone',
                controller: _emailCtrl,
                hint: 'example@email.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              KayanDesignTextField(
                label: ar ? 'كلمة المرور' : 'Password',
                controller: _passwordCtrl,
                hint: '••••••••',
                icon: Icons.lock_outline_rounded,
                obscureText: true,
              ),
            ] else
              KayanDesignTextField(
                label: ar ? 'رقم الجوال' : 'Phone number',
                controller: _phoneCtrl,
                hint: '05XXXXXXXX',
                icon: Icons.phone_iphone_rounded,
                keyboardType: TextInputType.phone,
              ),
            const SizedBox(height: 12),
            if (_tabIndex == 0)
              Row(
                children: [
                  KayanCheckRow(
                    label: ar ? 'تذكرني' : 'Remember me',
                    value: _remember,
                    onChanged: (v) => setState(() => _remember = v),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                    child: Text(
                      ar ? 'نسيت كلمة المرور؟' : 'Forgot password?',
                      style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.kBlue),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 18),
            KayanCtaButton(
              label: ar ? 'تسجيل الدخول' : 'Login',
              loading: _loading,
              variant: KayanCtaVariant.blue,
              onPressed: _loading
                  ? null
                  : () => _tabIndex == 0
                      ? _run(() => auth.loginWithEmail(_emailCtrl.text.trim(), _passwordCtrl.text))
                      : context.push(AppRoutes.otpVerify, extra: _phoneCtrl.text.trim()),
            ),
            const SizedBox(height: 20),
            KayanOrDivider(label: ar ? 'أو' : 'OR'),
            const SizedBox(height: 16),
            KayanSocialButton(label: 'Google', icon: Icons.g_mobiledata_rounded, onTap: () => _run(() => auth.loginWithGoogle())),
            const SizedBox(height: 10),
            KayanSocialButton(label: 'Apple', icon: Icons.apple_rounded, onTap: () => _run(() => auth.loginWithApple())),
            const SizedBox(height: 10),
            KayanSocialButton(label: 'Facebook', icon: Icons.facebook_rounded, onTap: () => _run(() => auth.loginWithFacebook())),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.push(AppRoutes.signup),
              child: Text(
                ar ? 'ليس لديك حساب؟ سجل الآن' : 'No account? Sign up',
                style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, color: KayanDesignTokens.kBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthTabs extends StatelessWidget {
  const _AuthTabs({required this.index, required this.isArabic, required this.onChanged});

  final int index;
  final bool isArabic;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final labels = [isArabic ? 'بريد إلكتروني' : 'Email', isArabic ? 'رقم الجوال' : 'Phone'];
    return Row(
      children: List.generate(labels.length, (i) {
        final selected = index == i;
        return Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: i == 0 ? 6 : 0, start: i == 1 ? 6 : 0),
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: selected ? KayanDesignTokens.gradBlue : null,
                  color: selected ? null : KayanDesignTokens.bg,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: selected ? Colors.transparent : KayanDesignTokens.border),
                ),
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: KayanDesignTokens.cairo(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : KayanDesignTokens.text2,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
