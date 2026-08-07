// Shop cart — light design (62-sh-cart.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../product/presentation/providers/product_providers.dart';

class ShopCartScreen extends ConsumerWidget {
  const ShopCartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final cart = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);
    final summary = cart.summary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'سلة المتجر' : 'Shop cart', onBack: () => context.pop()),
              Expanded(
                child: cart.items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shopping_cart_outlined, size: 48, color: KayanDesignTokens.muted.withValues(alpha: 0.5)),
                            const SizedBox(height: 12),
                            Text(ar ? 'السلة فارغة' : 'Cart is empty', style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted)),
                          ],
                        ),
                      )
                    : ListView(
                        children: [
                          ...cart.items.map((item) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: KayanDesignTokens.border),
                                boxShadow: KayanDesignTokens.shadowS,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(ar ? item.nameAr : item.nameEn, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                                        Text('${item.unitPrice.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}', style: KayanDesignTokens.cairo(color: KayanDesignTokens.oOrange, fontWeight: FontWeight.w800)),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      _QtyBtn(icon: Icons.remove, onTap: () => notifier.updateQuantity(item.cartItemId, item.quantity - 1)),
                                      Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('${item.quantity}', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800))),
                                      _QtyBtn(icon: Icons.add, onTap: () => notifier.updateQuantity(item.cartItemId, item.quantity + 1)),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 8),
                          _SumRow(ar ? 'المجموع' : 'Subtotal', '${summary.subtotal.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}'),
                          _SumRow(ar ? 'الشحن' : 'Shipping', '${summary.shipping.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}'),
                          _SumRow(ar ? 'الإجمالي' : 'Total', '${summary.total.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}', bold: true),
                        ],
                      ),
              ),
              if (cart.items.isNotEmpty)
                KayanCtaButton(
                  label: ar ? 'إتمام الشراء' : 'Checkout',
                  trailingIcon: Icons.lock_rounded,
                  variant: KayanCtaVariant.orange,
                  onPressed: () => context.push(AppRoutes.shopCheckout),
                ),
            ],
          ),
        ),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: KayanDesignTokens.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: KayanDesignTokens.border)),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: KayanDesignTokens.cairo(fontWeight: bold ? FontWeight.w800 : FontWeight.w500, color: KayanDesignTokens.text2)),
          Text(value, style: KayanDesignTokens.cairo(fontWeight: bold ? FontWeight.w900 : FontWeight.w700, color: bold ? KayanDesignTokens.oOrange : KayanDesignTokens.kBlueDeep)),
        ],
      ),
    );
  }
}
