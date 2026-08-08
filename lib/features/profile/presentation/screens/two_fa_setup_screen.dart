import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// إعداد التحقق الثنائي — light design
class TwoFaSetupScreen extends ConsumerStatefulWidget {
  const TwoFaSetupScreen({super.key});

  @override
  ConsumerState<TwoFaSetupScreen> createState() => _TwoFaSetupScreenState();
}

class _TwoFaSetupScreenState extends ConsumerState<TwoFaSetupScreen> {
  String _method = 'sms';

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
              KayanLightTopBar(title: ar ? 'التحقق الثنائي' : 'Two-factor auth', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      ar ? 'فعّل رمز تحقق إضافي عند تسجيل الدخول' : 'Enable an extra verification code at sign-in',
                      style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2, height: 1.6),
                    ),
                    const SizedBox(height: 20),
                    _MethodTile(
                      selected: _method == 'sms',
                      icon: Icons.sms_outlined,
                      title: ar ? 'رمز عبر SMS' : 'SMS code',
                      subtitle: ar ? 'استلم الرمز على جوالك المسجل' : 'Receive code on your registered phone',
                      onTap: () => setState(() => _method = 'sms'),
                    ),
                    const SizedBox(height: 10),
                    _MethodTile(
                      selected: _method == 'email',
                      icon: Icons.email_outlined,
                      title: ar ? 'رمز عبر البريد' : 'Email code',
                      subtitle: ar ? 'طريقة احتياطية عبر البريد' : 'Backup method via email',
                      onTap: () => setState(() => _method = 'email'),
                    ),
                    const SizedBox(height: 10),
                    _MethodTile(
                      selected: _method == 'app',
                      icon: Icons.phonelink_lock_outlined,
                      title: ar ? 'تطبيق المصادقة' : 'Authenticator app',
                      subtitle: ar ? 'Google Authenticator أو مشابه' : 'Google Authenticator or similar',
                      onTap: () => setState(() => _method = 'app'),
                    ),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'متابعة' : 'Continue',
                trailingIcon: Icons.arrow_back_rounded,
                variant: KayanCtaVariant.blue,
                onPressed: () => context.push(AppRoutes.twoFAVerify),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? KayanDesignTokens.kBlue.withValues(alpha: 0.06) : KayanDesignTokens.surface,
      borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
            border: Border.all(color: selected ? KayanDesignTokens.kBlue : KayanDesignTokens.border, width: selected ? 1.5 : 1),
          ),
          child: Row(
            children: [
              Icon(icon, color: KayanDesignTokens.kBlue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                    Text(subtitle, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                  ],
                ),
              ),
              if (selected) const Icon(Icons.check_circle_rounded, color: KayanDesignTokens.kBlue),
            ],
          ),
        ),
      ),
    );
  }
}
