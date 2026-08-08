// Order detail — light design
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

class _OrderDetail {
  const _OrderDetail({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.total,
    required this.statusAr,
    required this.statusEn,
    required this.date,
    required this.items,
  });

  final String id;
  final String titleAr;
  final String titleEn;
  final double total;
  final String statusAr;
  final String statusEn;
  final String date;
  final int items;
}

_OrderDetail _mockOrder(String id) {
  return _OrderDetail(
    id: id,
    titleAr: 'عطر فاخر + حقيبة يد',
    titleEn: 'Luxury perfume + handbag',
    total: 890,
    statusAr: 'قيد الشحن',
    statusEn: 'Shipping',
    date: '7 أغسطس 2026',
    items: 2,
  );
}

class OrderDetailLightScreen extends ConsumerWidget {
  const OrderDetailLightScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final order = _mockOrder(orderId);
    final color = order.statusEn == 'Delivered' ? KayanDesignTokens.kGreen : KayanDesignTokens.oOrange;

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: order.id,
            variant: KayanSectionHeroVariant.orange,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: KayanDesignTokens.surface,
                    borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                    border: Border.all(color: KayanDesignTokens.border),
                    boxShadow: KayanDesignTokens.shadowS,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(ar ? order.titleAr : order.titleEn, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, fontSize: 16))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(99)),
                            child: Text(ar ? order.statusAr : order.statusEn, style: KayanDesignTokens.cairo(fontSize: 10, fontWeight: FontWeight.w800, color: color)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _Row(icon: Icons.calendar_today_outlined, text: order.date),
                      _Row(icon: Icons.inventory_2_outlined, text: ar ? '${order.items} منتجات' : '${order.items} items'),
                      _Row(icon: Icons.payments_outlined, text: '${order.total.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}'),
                      _Row(icon: Icons.local_shipping_outlined, text: ar ? 'توصيل خلال 2-3 أيام' : 'Delivery in 2-3 days'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                KayanCtaButton(
                  label: ar ? 'تتبع الشحنة' : 'Track shipment',
                  trailingIcon: Icons.location_on_rounded,
                  variant: KayanCtaVariant.orange,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                KayanCtaButton(
                  label: ar ? 'إعادة الطلب' : 'Reorder',
                  trailingIcon: Icons.refresh_rounded,
                  variant: KayanCtaVariant.blue,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: KayanDesignTokens.oOrange),
          const SizedBox(width: 8),
          Text(text, style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.text2)),
        ],
      ),
    );
  }
}
