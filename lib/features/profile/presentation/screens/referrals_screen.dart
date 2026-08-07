import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// الإحالات — light design
class ReferralsScreen extends ConsumerWidget {
  const ReferralsScreen({super.key});

  static const _code = 'KAYAN-GCC-2026';

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
              KayanLightTopBar(title: ar ? 'الإحالات' : 'Referrals', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      ar ? 'ادعُ أصدقاءك واربح نقاطاً' : 'Invite friends and earn points',
                      style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: KayanDesignTokens.gradGold,
                        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusL),
                        boxShadow: KayanDesignTokens.shadowM,
                      ),
                      child: Column(
                        children: [
                          Text(ar ? 'رمز الإحالة' : 'Referral code', style: KayanDesignTokens.cairo(color: const Color(0xFF402C00))),
                          const SizedBox(height: 8),
                          Text(_code, style: KayanDesignTokens.cairo(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF402C00))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _InfoCard(
                      icon: Icons.card_giftcard_rounded,
                      title: ar ? 'مكافأة لكل صديق' : 'Reward per friend',
                      body: ar ? '100 نقطة لكل صديق يسجّل ويكمل أول طلب' : '100 points when a friend signs up and completes their first order',
                    ),
                    _InfoCard(
                      icon: Icons.people_outline_rounded,
                      title: ar ? 'إحالاتك' : 'Your referrals',
                      body: ar ? '3 أصدقاء انضموا عبر رمزك' : '3 friends joined using your code',
                    ),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'مشاركة الرمز' : 'Share code',
                trailingIcon: Icons.share_rounded,
                variant: KayanCtaVariant.gold,
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: _code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'تم نسخ الرمز' : 'Code copied')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: KayanDesignTokens.surface,
          borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
          border: Border.all(color: KayanDesignTokens.border),
          boxShadow: KayanDesignTokens.shadowS,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: KayanDesignTokens.kBlue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(body, style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.text2, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
