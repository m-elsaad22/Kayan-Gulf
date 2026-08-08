import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

/// بطاقات الولاء — light design
class LoyaltyCardsScreen extends ConsumerWidget {
  const LoyaltyCardsScreen({super.key});

  static const _tiers = [
    ('ذهبي', 'Gold', '1,250', Icons.workspace_premium_rounded, KayanDesignTokens.gradGold),
    ('بلاتيني', 'Platinum', '3,800', Icons.diamond_rounded, KayanDesignTokens.gradBlue),
    ('فضي', 'Silver', '420', Icons.star_rounded, LinearGradient(colors: [KayanDesignTokens.silver, Color(0xFFD8E0EA)])),
  ];

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
              KayanLightTopBar(title: ar ? 'بطاقات الولاء' : 'Loyalty cards', onBack: () => context.pop()),
              const SizedBox(height: 8),
              Text(
                ar ? 'نقاطك ومزاياك حسب مستوى العضوية' : 'Your points and benefits by membership tier',
                style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    for (final t in _tiers)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: t.$5,
                            borderRadius: BorderRadius.circular(KayanDesignTokens.radiusL),
                            boxShadow: KayanDesignTokens.shadowM,
                          ),
                          child: Row(
                            children: [
                              Icon(t.$4, color: Colors.white, size: 32),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ar ? t.$1 : t.$2, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white)),
                                    Text(
                                      ar ? '${t.$3} نقطة' : '${t.$3} pts',
                                      style: KayanDesignTokens.cairo(color: Colors.white.withValues(alpha: 0.9)),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_left_rounded, color: Colors.white.withValues(alpha: 0.8)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
