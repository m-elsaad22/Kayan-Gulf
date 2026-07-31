import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../providers/delivery_providers.dart';

/// Matches design/html/95-or-cart.html
class DeliveryCartScreen extends ConsumerWidget {
  const DeliveryCartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final lines = ref.watch(deliveryCartProvider);
    final cart = ref.read(deliveryCartProvider.notifier);
    final subtotal = ref.watch(deliveryCartSubtotalProvider);
    final deliveryFee = lines.isEmpty ? 0.0 : 5.0;
    final total = subtotal + deliveryFee;

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: KayanDesignTokens.kBlueDeep,
        elevation: 0,
        title: Text(ar ? 'سلة الطلبات' : 'Order cart', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
      ),
      body: lines.isEmpty
          ? Center(
              child: Text(
                ar ? 'السلة فارغة' : 'Your cart is empty',
                style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      ...lines.map((line) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: KayanDesignTokens.border),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(line.item.name(ar), style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                                    Text(
                                      '${line.item.price.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
                                      style: KayanDesignTokens.cairo(color: KayanDesignTokens.oOrange, fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  _QtyBtn(icon: Icons.remove, onTap: () => cart.decrement(line.item.id)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text('${line.quantity}', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                                  ),
                                  _QtyBtn(icon: Icons.add, onTap: () => cart.increment(line.item.id)),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      _SumRow(ar ? 'المجموع الفرعي' : 'Subtotal', '${subtotal.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}'),
                      _SumRow(ar ? 'التوصيل' : 'Delivery', '${deliveryFee.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}'),
                      _SumRow(ar ? 'الإجمالي' : 'Total', '${total.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}', bold: true),
                    ],
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: KayanDesignPrimaryButton(
                      label: ar ? 'متابعة للعنوان' : 'Continue to address',
                      onPressed: () => context.push(AppRoutes.deliveryAddress),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  const _QtyBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: KayanDesignTokens.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: KayanDesignTokens.border),
        ),
        child: Icon(icon, size: 16, color: KayanDesignTokens.kBlue),
      ),
    );
  }
}

class _SumRow extends StatelessWidget {
  const _SumRow(this.label, this.value, {this.bold = false});
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(label, style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2, fontWeight: bold ? FontWeight.w900 : FontWeight.w600)),
          const Spacer(),
          Text(value, style: KayanDesignTokens.cairo(color: KayanDesignTokens.kBlueDeep, fontWeight: bold ? FontWeight.w900 : FontWeight.w700, fontSize: bold ? 16 : 14)),
        ],
      ),
    );
  }
}
