import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

/// اكسب نقاط — light design
class EarnPointsScreen extends ConsumerWidget {
  const EarnPointsScreen({super.key});

  static const _ways = [
    (Icons.shopping_bag_rounded, 'التسوق', 'Shopping', '1 نقطة / 10 ر.س', '1 pt / 10 SAR'),
    (Icons.home_repair_service_rounded, 'الخدمات', 'Services', '2 نقطة / 10 ر.س', '2 pts / 10 SAR'),
    (Icons.share_rounded, 'الإحالات', 'Referrals', '100 نقطة / صديق', '100 pts / friend'),
    (Icons.rate_review_outlined, 'التقييمات', 'Reviews', '25 نقطة / تقييم', '25 pts / review'),
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
              KayanLightTopBar(title: ar ? 'اكسب نقاط' : 'Earn points', onBack: () => context.pop()),
              const SizedBox(height: 12),
              Text(ar ? 'طرق سهلة لزيادة رصيدك' : 'Easy ways to grow your balance', style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    for (final w in _ways)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: KayanDesignTokens.surface,
                            borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                            border: Border.all(color: KayanDesignTokens.border),
                            boxShadow: KayanDesignTokens.shadowS,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: KayanDesignTokens.kBlue.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(w.$1, color: KayanDesignTokens.kBlue),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ar ? w.$2 : w.$3, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                                    Text(ar ? w.$4 : w.$5, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                                  ],
                                ),
                              ),
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
