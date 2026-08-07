import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// استبدال النقاط — light design
class RedeemPointsScreen extends ConsumerWidget {
  const RedeemPointsScreen({super.key});

  static const _rewards = [
    ('500', 'قسيمة 50 ر.س', '50 SAR voucher'),
    ('1200', 'ترقية مميزة شهر', 'Premium month'),
    ('2000', 'شحن مجاني 3 مرات', '3 free deliveries'),
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
              KayanLightTopBar(title: ar ? 'استبدال النقاط' : 'Redeem points', onBack: () => context.pop()),
              const SizedBox(height: 12),
              Text(ar ? 'حوّل نقاطك إلى خصومات ومزايا' : 'Turn points into discounts and perks', style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    for (final r in _rewards)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
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
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: KayanDesignTokens.gradGold,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('${r.$1} ${ar ? 'نقطة' : 'pts'}', style: KayanDesignTokens.cairo(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF402C00))),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Text(ar ? r.$2 : r.$3, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700))),
                              Icon(Icons.chevron_left_rounded, color: KayanDesignTokens.muted),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'استبدال الآن' : 'Redeem now',
                trailingIcon: Icons.redeem_rounded,
                variant: KayanCtaVariant.gold,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'تم الاستبدال' : 'Redeemed successfully')),
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
