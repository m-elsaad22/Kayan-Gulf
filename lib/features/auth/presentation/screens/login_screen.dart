// Login — Gmail primary, phone OTP kept for later Unifonic subscription
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_config.dart';
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
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    HapticFeedback.selectionClick();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await action();
      if (mounted) context.go(AppRoutes.dashboard);
    } catch (e) {
      if (!mounted) return;
      final ar = ref.read(isArabicProvider);
      final msg = e.toString();
      String friendly;
      if (msg.contains('google_cancelled')) {
        friendly = ar ? 'تم إلغاء تسجيل الدخول بجوجل' : 'Google sign-in cancelled';
      } else if (msg.contains('google_sign_in') || msg.contains('PlatformException')) {
        friendly = ar
            ? 'تعذر فتح جوجل. استخدم بريد Gmail وكلمة المرور بالأعلى، أو أضف SHA-1 في Google Cloud.'
            : 'Google Sign-In failed. Use Gmail + password above, or configure SHA-1 in Google Cloud.';
      } else if (msg.contains('apple_sign_in') || msg.contains('facebook_sign_in')) {
        friendly = ar ? 'هذه الطريقة غير مفعّلة حاليًا' : 'This sign-in method is not enabled yet';
      } else if (msg.contains('invalid_credentials')) {
        friendly = ar ? 'البريد أو كلمة المرور غير صحيحة' : 'Invalid email or password';
      } else {
        friendly = ar ? 'تعذر تسجيل الدخول. حاول مرة أخرى.' : 'Sign-in failed. Please try again.';
      }
      setState(() => _error = friendly);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
              children: [
                const KayanBrandLogo(size: 56),
                const SizedBox(height: 14),
                KayanEntryTitle(before: ar ? 'تسجيل ' : 'Sign ', highlight: ar ? 'الدخول' : 'in'),
                const SizedBox(height: 8),
                KayanEntrySubtitle(
                  ar
                      ? 'سجّل بجيميل الآن — الجوال OTP لاحقًا بعد تفعيل الخدمة'
                      : 'Sign in with Gmail now — phone OTP after SMS is activated',
                ),
              ],
            ),
          ),
        ],
      ),
      sheet: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KayanSocialButton(
              label: ar ? 'المتابعة باستخدام Gmail' : 'Continue with Gmail',
              icon: Icons.g_mobiledata_rounded,
              onTap: () {
                if (_loading) return;
                _run(() => auth.loginWithGoogle());
              },
            ),
            const SizedBox(height: 14),
            KayanOrDivider(label: ar ? 'أو بالبريد وكلمة المرور' : 'OR email & password'),
            const SizedBox(height: 14),
            _AuthTabs(index: _tabIndex, isArabic: ar, onChanged: (i) => setState(() => _tabIndex = i)),
            const SizedBox(height: 18),
            if (_tabIndex == 0) ...[
              KayanDesignTextField(
                label: ar ? 'بريد Gmail / الإلكتروني' : 'Gmail / Email',
                controller: _emailCtrl,
                hint: 'name@gmail.com',
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
            ] else ...[
              KayanDesignTextField(
                label: ar ? 'رقم الجوال' : 'Phone number',
                controller: _phoneCtrl,
                hint: '05XXXXXXXX',
                icon: Icons.phone_iphone_rounded,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              Text(
                ar
                    ? 'OTP عبر SMS سيعمل بعد الاشتراك في Unifonic. حاليًا للتجربة المحلية فقط.'
                    : 'SMS OTP will work after Unifonic subscription. Local demo only for now.',
                style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted, height: 1.5),
              ),
            ],
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
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: KayanDesignTokens.cairo(fontSize: 12.5, color: Colors.red.shade700, height: 1.5),
              ),
            ],
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
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.push(AppRoutes.signup),
              child: Text(
                ar ? 'ليس لديك حساب؟ سجل الآن' : 'No account? Sign up',
                style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, color: KayanDesignTokens.kBlue),
              ),
            ),
            TextButton(
              onPressed: () async {
                final uri = Uri.parse(AppConfig.publisherUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: Text(
                ar ? 'ركن التطور — الموقع' : 'Rukn Eltatawer website',
                style: KayanDesignTokens.cairo(fontSize: 12.5, color: KayanDesignTokens.muted),
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
    final labels = [isArabic ? 'Gmail / بريد' : 'Gmail / Email', isArabic ? 'رقم الجوال' : 'Phone'];
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
