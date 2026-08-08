import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// الاشتراكات — light design
class SubscriptionsScreen extends ConsumerWidget {
  const SubscriptionsScreen({super.key});

  static const _plans = [
    ('KAYAN Plus', 'كيان بلس', '29', Icons.star_rounded, KayanDesignTokens.gradGold),
    ('KAYAN Business', 'كيان للأعمال', '99', Icons.business_center_rounded, KayanDesignTokens.gradBlue),
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
              KayanLightTopBar(title: ar ? 'الاشتراكات' : 'Subscriptions', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      ar ? 'خطط اشتراك لخدمات أكثر قيمة' : 'Subscription plans for more value',
                      style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2),
                    ),
                    const SizedBox(height: 20),
                    for (final p in _plans)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: p.$5,
                            borderRadius: BorderRadius.circular(KayanDesignTokens.radiusL),
                            boxShadow: KayanDesignTokens.shadowM,
                          ),
                          child: Row(
                            children: [
                              Icon(p.$4, color: Colors.white, size: 28),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ar ? p.$2 : p.$1, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w900, fontSize: 17, color: Colors.white)),
                                    Text(
                                      ar ? '${p.$3} ر.س / شهر' : '${p.$3} SAR / month',
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
              KayanCtaButton(
                label: ar ? 'إدارة اشتراكي' : 'Manage my plan',
                trailingIcon: Icons.settings_rounded,
                variant: KayanCtaVariant.blue,
                onPressed: () => context.push(AppRoutes.manageSubscription),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
