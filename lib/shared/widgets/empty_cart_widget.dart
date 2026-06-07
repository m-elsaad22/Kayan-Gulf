import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class EmptyCartWidget extends StatelessWidget {
  final VoidCallback? onShop;
  final bool isArabic;

  const EmptyCartWidget({
    super.key,
    this.onShop,
    this.isArabic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 72,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'سلتك فارغة' : 'Your cart is empty',
              style: isArabic
                  ? AppTextStyles.arabicTitleMedium
                  : AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? 'تصفّح المتجر وأضف منتجاتك المفضلة.'
                  : 'Browse the shop and add your favorites.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (onShop != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onShop,
                child: Text(isArabic ? 'تسوق الآن' : 'Shop Now'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
