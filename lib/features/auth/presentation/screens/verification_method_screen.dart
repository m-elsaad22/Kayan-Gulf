import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

/// اختيار طريقة التحقق — light design
class VerificationMethodScreen extends ConsumerWidget {
  const VerificationMethodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'طريقة التحقق' : 'Verification method', onBack: () => context.pop()),
              const SizedBox(height: 12),
              Text(
                ar ? 'اختر كيف تريد استلام رمز التحقق' : 'Choose how to receive your verification code',
                style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2),
              ),
              const SizedBox(height: 20),
              _MethodCard(
                icon: Icons.email_outlined,
                gradient: KayanDesignTokens.gradBlue,
                title: ar ? 'البريد الإلكتروني' : 'Email',
                subtitle: ar ? 'رمز عبر البريد' : 'Code via email',
                onTap: () => context.push(AppRoutes.emailPin),
              ),
              const SizedBox(height: 12),
              _MethodCard(
                icon: Icons.phone_iphone_rounded,
                gradient: KayanDesignTokens.gradGreen,
                title: ar ? 'رقم الجوال' : 'Phone',
                subtitle: ar ? 'رمز عبر SMS' : 'Code via SMS',
                onTap: () => context.push(AppRoutes.phoneInput),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final LinearGradient gradient;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: KayanDesignTokens.surface,
          borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
          border: Border.all(color: KayanDesignTokens.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
                  Text(subtitle, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_left_rounded, color: KayanDesignTokens.muted),
          ],
        ),
      ),
    );
  }
}
