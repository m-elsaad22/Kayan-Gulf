// Signup — matches design/html/09-signup.html
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

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
    final ar = ref.watch(isArabicProvider);

    return KayanEntryScaffold(
      smallHero: true,
      heroHeight: 210,
      hero: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: KayanHeroIconButton(
                icon: Icons.arrow_forward_ios_rounded,
                onTap: () => context.pop(),
              ),
            ),
            const KayanBrandLogo(size: 56),
            const SizedBox(height: 14),
            KayanEntryTitle(before: ar ? 'إنشاء ' : 'Create ', highlight: ar ? 'حساب جديد' : 'account'),
            const SizedBox(height: 8),
            KayanEntrySubtitle(ar ? 'انضم إلى كيان في أقل من دقيقة' : 'Join KAYAN in under a minute'),
          ],
        ),
      ),
      sheet: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KayanDesignTextField(
              label: ar ? 'الاسم الكامل' : 'Full name',
              controller: _nameCtrl,
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 16),
            KayanDesignTextField(
              label: ar ? 'البريد الإلكتروني' : 'Email',
              controller: _emailCtrl,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            KayanDesignTextField(
              label: ar ? 'رقم الجوال' : 'Phone',
              controller: _phoneCtrl,
              icon: Icons.phone_iphone_rounded,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            KayanDesignTextField(
              label: ar ? 'كلمة المرور' : 'Password',
              controller: _passwordCtrl,
              icon: Icons.lock_outline_rounded,
              obscureText: true,
            ),
            const SizedBox(height: 14),
            KayanCheckRow(
              label: ar ? 'أوافق على الشروط والأحكام وسياسة الخصوصية' : 'I agree to terms and privacy policy',
              value: _accepted,
              onChanged: (v) => setState(() => _accepted = v),
            ),
            const SizedBox(height: 20),
            KayanCtaButton(
              label: ar ? 'إنشاء حساب' : 'Create account',
              loading: _loading,
              onPressed: _accepted && !_loading ? _submit : null,
            ),
          ],
        ),
      ),
    );
  }
}
