// Order details — matches design/html/101-or-order-details.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../data/mock/delivery_mock_data.dart';
import '../../data/models/delivery_models.dart';

class DeliveryOrderDetailScreen extends ConsumerWidget {
  const DeliveryOrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  DeliveryOrder? get _order {
    try {
      return mockDeliveryOrders.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return mockDeliveryOrders.isNotEmpty ? mockDeliveryOrders.first : null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final order = _order;
    if (order == null) {
      return Scaffold(body: Center(child: Text(ar ? 'الطلب غير موجود' : 'Order not found')));
    }

    final status = ar ? order.statusAr : order.statusEn;
    final canTrack = order.statusEn == 'On the way';

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'تفاصيل الطلب' : 'Order details',
            variant: KayanSectionHeroVariant.redOrange,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: KayanDesignTokens.border), boxShadow: KayanDesignTokens.shadowS),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(gradient: KayanDesignTokens.gradOrange, borderRadius: BorderRadius.circular(12)),
                        child: Icon(order.vendor.icon, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order.vendor.name(ar), style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
                            Text('#${order.id}', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                          ],
                        ),
                      ),
                      Text(status, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.oOrange)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                KayanSectionHeader(title: ar ? 'العناصر' : 'Items'),
                const SizedBox(height: 10),
                ...order.lines.map((line) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Text('${line.quantity}x', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlue)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(line.item.name(ar), style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2))),
                        Text('${line.subtotal.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  );
                }),
                const Divider(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ar ? 'الإجمالي' : 'Total', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, fontSize: 16)),
                    Text('${order.total.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w900, fontSize: 18, color: KayanDesignTokens.oOrange)),
                  ],
                ),
                const SizedBox(height: 20),
                if (canTrack)
                  KayanCtaButton(
                    label: ar ? 'تتبع الطلب' : 'Track order',
                    trailingIcon: Icons.delivery_dining_rounded,
                    variant: KayanCtaVariant.orange,
                    onPressed: () => context.push(AppRoutes.deliveryTracking),
                  ),
                if (order.statusEn == 'Delivered') ...[
                  const SizedBox(height: 10),
                  KayanCtaButton(
                    label: ar ? 'قيّم الطلب' : 'Rate order',
                    trailingIcon: Icons.star_rounded,
                    variant: KayanCtaVariant.blue,
                    onPressed: () => context.push(AppRoutes.deliveryRatePath(order.id)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
