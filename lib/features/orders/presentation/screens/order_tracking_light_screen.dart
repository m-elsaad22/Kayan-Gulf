// Order tracking — light design
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

class OrderTrackingLightScreen extends ConsumerWidget {
  const OrderTrackingLightScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final steps = ar
        ? ['تم الطلب', 'قيد التجهيز', 'تم الشحن', 'في الطريق', 'تم التوصيل']
        : ['Ordered', 'Processing', 'Shipped', 'On the way', 'Delivered'];
    const activeStep = 3;

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'تتبع الشحنة' : 'Track shipment',
            variant: KayanSectionHeroVariant.orange,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: [
                Text(orderId, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.oOrange)),
                const SizedBox(height: 16),
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: KayanDesignTokens.oOrange.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                    border: Border.all(color: KayanDesignTokens.border),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.local_shipping_rounded, size: 40, color: KayanDesignTokens.oOrange),
                      const SizedBox(height: 8),
                      Text(ar ? 'الشحنة في الطريق — الوصول خلال يومين' : 'Shipment on the way — ETA 2 days', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                KayanSectionHeader(title: ar ? 'حالة الطلب' : 'Order status'),
                const SizedBox(height: 12),
                for (var i = 0; i < steps.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i <= activeStep ? KayanDesignTokens.oOrange : KayanDesignTokens.border,
                          ),
                          child: Icon(i < activeStep ? Icons.check_rounded : Icons.circle, size: 14, color: i <= activeStep ? Colors.white : KayanDesignTokens.muted),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            steps[i],
                            style: KayanDesignTokens.cairo(
                              fontWeight: i == activeStep ? FontWeight.w800 : FontWeight.w600,
                              color: i <= activeStep ? KayanDesignTokens.kBlueDeep : KayanDesignTokens.muted,
                            ),
                          ),
                        ),
                      ],
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
