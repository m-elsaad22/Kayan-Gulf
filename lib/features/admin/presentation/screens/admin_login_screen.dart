import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/admin_data_service.dart';
import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// دخول لوحة الإدارة — light design
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final ok = await AdminDataService.instance.login(
      _userCtrl.text.trim(),
      _passCtrl.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      context.go(AppRoutes.adminDashboard);
    } else {
      setState(() => _error = 'بيانات الدخول غير صحيحة');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: KayanEntryScaffold(
        smallHero: true,
        heroHeight: 220,
        hero: const Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            children: [
              KayanBrandLogo(size: 64),
              SizedBox(height: 14),
              KayanEntryTitle(before: 'دخول ', highlight: 'الإدارة'),
              SizedBox(height: 8),
              KayanEntrySubtitle('لوحة تحكم كيان — CMS'),
            ],
          ),
        ),
        sheet: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KayanDesignTextField(
              label: 'اسم المستخدم',
              controller: _userCtrl,
              hint: 'admin',
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 16),
            KayanDesignTextField(
              label: 'كلمة المرور',
              controller: _passCtrl,
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              obscureText: true,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.danger)),
            ],
            const SizedBox(height: 20),
            KayanCtaButton(
              label: 'تسجيل الدخول',
              loading: _loading,
              variant: KayanCtaVariant.blue,
              onPressed: _loading ? null : _login,
            ),
          ],
        ),
      ),
    );
  }
}
