// Shop orders — matches design/html/66-sh-my-orders.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';

class _ShopOrder {
  const _ShopOrder({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.total,
    required this.statusAr,
    required this.statusEn,
    required this.icon,
  });

  final String id;
  final String titleAr;
  final String titleEn;
  final double total;
  final String statusAr;
  final String statusEn;
  final IconData icon;
}

const _mockShopOrders = [
  _ShopOrder(
    id: 'sh-2001',
    titleAr: 'عطر فاخر + حقيبة يد',
    titleEn: 'Luxury perfume + handbag',
    total: 890,
    statusAr: 'قيد الشحن',
    statusEn: 'Shipping',
    icon: Icons.shopping_bag_rounded,
  ),
  _ShopOrder(
    id: 'sh-2002',
    titleAr: 'سماعات لاسلكية',
    titleEn: 'Wireless earbuds',
    total: 249,
    statusAr: 'تم التسليم',
    statusEn: 'Delivered',
    icon: Icons.headphones_rounded,
  ),
];

class ShopOrdersScreen extends ConsumerStatefulWidget {
  const ShopOrdersScreen({super.key});

  @override
  ConsumerState<ShopOrdersScreen> createState() => _ShopOrdersScreenState();
}

class _ShopOrdersScreenState extends ConsumerState<ShopOrdersScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final tabs = ar ? ['الكل', 'جارية', 'مكتملة'] : ['All', 'Active', 'Done'];
    final orders = switch (_tab) {
      1 => _mockShopOrders.where((o) => o.statusEn == 'Shipping').toList(),
      2 => _mockShopOrders.where((o) => o.statusEn == 'Delivered').toList(),
      _ => _mockShopOrders,
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'طلبات المتجر' : 'Shop orders', onBack: () => context.pop()),
              const SizedBox(height: 10),
              KayanFilterSlotRow(labels: tabs, selectedIndex: _tab, onSelected: (i) => setState(() => _tab = i)),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: orders.map((o) {
                    final color = o.statusEn == 'Delivered' ? KayanDesignTokens.kGreen : KayanDesignTokens.oOrange;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: KayanDesignTokens.border),
                        boxShadow: KayanDesignTokens.shadowS,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(gradient: KayanDesignTokens.gradOrange, borderRadius: BorderRadius.circular(14)),
                            child: Icon(o.icon, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ar ? o.titleAr : o.titleEn, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
                                Text('${o.total.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(99)),
                            child: Text(ar ? o.statusAr : o.statusEn, style: KayanDesignTokens.cairo(fontSize: 10, fontWeight: FontWeight.w800, color: color)),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              KayanCtaButton(
                label: ar ? 'تسوق الآن' : 'Shop now',
                trailingIcon: Icons.storefront_rounded,
                variant: KayanCtaVariant.orange,
                onPressed: () => context.go(AppRoutes.shop),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
