import 'package:flutter/material.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../widgets/design/kayan_entry_widgets.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key, this.onShop, this.isArabic = false});

  final VoidCallback? onShop;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 72, color: KayanDesignTokens.muted.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(isArabic ? 'سلتك فارغة' : 'Your cart is empty', style: KayanDesignTokens.cairo(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(
              isArabic ? 'تصفّح المتجر وأضف منتجاتك المفضلة.' : 'Browse the shop and add your favorites.',
              textAlign: TextAlign.center,
              style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.muted),
            ),
            if (onShop != null) ...[
              const SizedBox(height: 20),
              KayanCtaButton(label: isArabic ? 'تسوق الآن' : 'Shop now', variant: KayanCtaVariant.orange, trailingIcon: Icons.storefront_rounded, onPressed: onShop),
            ],
          ],
        ),
      ),
    );
  }
}
