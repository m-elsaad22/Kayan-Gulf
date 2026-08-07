// My orders — matches design/html/100-or-my-orders.html
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

class DeliveryMyOrdersScreen extends ConsumerStatefulWidget {
  const DeliveryMyOrdersScreen({super.key});

  @override
  ConsumerState<DeliveryMyOrdersScreen> createState() => _DeliveryMyOrdersScreenState();
}

class _DeliveryMyOrdersScreenState extends ConsumerState<DeliveryMyOrdersScreen> {
  int _tab = 0;

  List<DeliveryOrder> _filter(List<DeliveryOrder> all, bool ar) {
    return switch (_tab) {
      1 => all.where((o) => o.statusEn == 'On the way').toList(),
      2 => all.where((o) => o.statusEn == 'Delivered').toList(),
      3 => all.where((o) => o.statusEn == 'Cancelled').toList(),
      _ => all,
    };
  }

  Color _statusColor(String statusEn) => switch (statusEn) {
        'On the way' => KayanDesignTokens.kBlue,
        'Delivered' => KayanDesignTokens.kGreen,
        'Cancelled' => KayanDesignTokens.danger,
        _ => KayanDesignTokens.muted,
      };

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final tabs = ar ? ['الكل', 'جارية', 'مكتملة', 'ملغية'] : ['All', 'Active', 'Done', 'Cancelled'];
    final orders = _filter(mockDeliveryOrders, ar);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'طلباتي' : 'My orders', onBack: () => context.pop()),
              const SizedBox(height: 10),
              KayanFilterSlotRow(labels: tabs, selectedIndex: _tab, onSelected: (i) => setState(() => _tab = i)),
              const SizedBox(height: 14),
              Expanded(
                child: orders.isEmpty
                    ? Center(child: Text(ar ? 'لا توجد طلبات' : 'No orders', style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted)))
                    : ListView(
                        children: orders.map((order) {
                          final status = ar ? order.statusAr : order.statusEn;
                          final color = _statusColor(order.statusEn);
                          return GestureDetector(
                            onTap: () => context.push(AppRoutes.deliveryOrderPath(order.id)),
                            child: Container(
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
                                    decoration: BoxDecoration(
                                      gradient: KayanDesignTokens.gradOrange,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(order.vendor.icon, color: Colors.white),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(order.vendor.name(ar), style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
                                        Text(
                                          '${order.lines.length} ${ar ? 'عناصر' : 'items'} · ${order.total.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
                                          style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(99),
                                        ),
                                        child: Text(status, style: KayanDesignTokens.cairo(fontSize: 10, fontWeight: FontWeight.w800, color: color)),
                                      ),
                                      if (order.statusEn == 'Delivered')
                                        TextButton(
                                          onPressed: () => context.push(AppRoutes.deliveryRatePath(order.id)),
                                          child: Text(ar ? 'قيّم' : 'Rate', style: KayanDesignTokens.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: KayanDesignTokens.kBlue)),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
