import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// 07-auth-reset — إعادة تعيين كلمة المرور
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: 'كلمة مرور جديدة', onBack: () => context.pop()),
              const SizedBox(height: 20),
              Text(
                'أدخل كلمة المرور الجديدة لحسابك',
                style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2, height: 1.8),
              ),
              const SizedBox(height: 20),
              KayanDesignTextField(
                controller: _password,
                label: 'كلمة المرور الجديدة',
                hint: '8 أحرف على الأقل',
                icon: Icons.lock_outline_rounded,
                obscureText: true,
              ),
              const SizedBox(height: 14),
              KayanDesignTextField(
                controller: _confirm,
                label: 'تأكيد كلمة المرور',
                hint: 'أعد إدخال كلمة المرور',
                icon: Icons.lock_outline_rounded,
                obscureText: true,
              ),
              const Spacer(),
              KayanCtaButton(
                label: 'حفظ كلمة المرور',
                trailingIcon: Icons.check_rounded,
                variant: KayanCtaVariant.blue,
                onPressed: () {
                  if (_password.text.length < 8) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('كلمة المرور قصيرة جداً')),
                    );
                    return;
                  }
                  if (_password.text != _confirm.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('كلمتا المرور غير متطابقتين')),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تحديث كلمة المرور')),
                  );
                  context.go(AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
