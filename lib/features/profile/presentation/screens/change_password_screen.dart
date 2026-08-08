import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// 86-pr-change-password — تغيير كلمة المرور
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
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
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'تغيير كلمة المرور' : 'Change password', onBack: () => context.pop()),
              const SizedBox(height: 20),
              KayanDesignTextField(
                controller: _current,
                label: ar ? 'كلمة المرور الحالية' : 'Current password',
                icon: Icons.lock_outline_rounded,
                obscureText: true,
              ),
              const SizedBox(height: 14),
              KayanDesignTextField(
                controller: _newPass,
                label: ar ? 'كلمة المرور الجديدة' : 'New password',
                hint: ar ? '8 أحرف على الأقل' : 'At least 8 characters',
                icon: Icons.lock_reset_rounded,
                obscureText: true,
              ),
              const SizedBox(height: 14),
              KayanDesignTextField(
                controller: _confirm,
                label: ar ? 'تأكيد كلمة المرور' : 'Confirm password',
                icon: Icons.lock_outline_rounded,
                obscureText: true,
              ),
              const Spacer(),
              KayanCtaButton(
                label: ar ? 'تحديث كلمة المرور' : 'Update password',
                trailingIcon: Icons.check_rounded,
                variant: KayanCtaVariant.blue,
                onPressed: () {
                  if (_newPass.text.length < 8) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(ar ? 'كلمة المرور الجديدة قصيرة' : 'New password is too short')),
                    );
                    return;
                  }
                  if (_newPass.text != _confirm.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(ar ? 'التأكيد غير متطابق' : 'Confirmation does not match')),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'تم تغيير كلمة المرور' : 'Password changed')),
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
