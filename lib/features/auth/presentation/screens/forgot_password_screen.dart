// Forgot password — light design (11-forgot-password.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'نسيت كلمة المرور' : 'Forgot password', onBack: () => context.pop()),
              const SizedBox(height: 20),
              Text(ar ? 'أدخل بريدك لإرسال رمز التحقق' : 'Enter your email to receive a verification code', style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2, height: 1.8)),
              const SizedBox(height: 20),
              KayanDesignTextField(
                label: ar ? 'البريد الإلكتروني' : 'Email',
                hint: 'name@example.com',
                icon: Icons.email_outlined,
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
              ),
              const Spacer(),
              KayanCtaButton(
                label: ar ? 'إرسال الرمز' : 'Send code',
                trailingIcon: Icons.arrow_back_rounded,
                variant: KayanCtaVariant.blue,
                onPressed: () => context.push(AppRoutes.resetPassword),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
