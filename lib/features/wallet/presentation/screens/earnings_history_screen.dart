import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

/// سجل الأرباح — light design
class EarningsHistoryScreen extends ConsumerWidget {
  const EarningsHistoryScreen({super.key});

  static const _items = [
    ('+320', 'إعلان مميز', 'Featured ad', 'أمس', 'Yesterday', true),
    ('+150', 'خدمة مكتملة', 'Completed service', '3 أيام', '3 days ago', true),
    ('-100', 'سحب أرباح', 'Withdrawal', 'أسبوع', '1 week ago', false),
    ('+480', 'مبيعات متجر', 'Shop sales', 'أسبوعين', '2 weeks ago', true),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'سجل الأرباح' : 'Earnings history',
            variant: KayanSectionHeroVariant.blue,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(gradient: KayanDesignTokens.gradGold, borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ar ? 'أرباح هذا الشهر' : 'This month', style: KayanDesignTokens.cairo(color: const Color(0xFF402C00))),
                      Text('2,480 ${ar ? 'ر.س' : 'SAR'}', style: KayanDesignTokens.cairo(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF402C00))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                for (final i in _items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: KayanDesignTokens.surface,
                        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                        border: Border.all(color: KayanDesignTokens.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ar ? i.$2 : i.$3, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                                Text(ar ? i.$4 : i.$5, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                              ],
                            ),
                          ),
                          Text(i.$1, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w900, color: i.$6 ? KayanDesignTokens.kGreen : KayanDesignTokens.danger)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
