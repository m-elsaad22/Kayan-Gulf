import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// 86-pr-change-password — تغيير كلمة المرور
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _current = TextEditingController();
  final _newPass = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _newPass.dispose();
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
              KayanLightTopBar(title: 'تغيير كلمة المرور', onBack: () => context.pop()),
              const SizedBox(height: 20),
              KayanDesignTextField(
                controller: _current,
                label: 'كلمة المرور الحالية',
                icon: Icons.lock_outline_rounded,
                obscureText: true,
              ),
              const SizedBox(height: 14),
              KayanDesignTextField(
                controller: _newPass,
                label: 'كلمة المرور الجديدة',
                hint: '8 أحرف على الأقل',
                icon: Icons.lock_reset_rounded,
                obscureText: true,
              ),
              const SizedBox(height: 14),
              KayanDesignTextField(
                controller: _confirm,
                label: 'تأكيد كلمة المرور',
                icon: Icons.lock_outline_rounded,
                obscureText: true,
              ),
              const Spacer(),
              KayanCtaButton(
                label: 'تحديث كلمة المرور',
                trailingIcon: Icons.check_rounded,
                variant: KayanCtaVariant.blue,
                onPressed: () {
                  if (_newPass.text.length < 8) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('كلمة المرور الجديدة قصيرة')),
                    );
                    return;
                  }
                  if (_newPass.text != _confirm.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('التأكيد غير متطابق')),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تغيير كلمة المرور')),
                  );
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
