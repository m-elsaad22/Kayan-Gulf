import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class EmptyWishlistWidget extends StatelessWidget {
  final VoidCallback? onBrowse;
  final bool isArabic;

  const EmptyWishlistWidget({
    super.key,
    this.onBrowse,
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
              Icons.favorite_border_rounded,
              size: 72,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'لا توجد مفضلات' : 'No favorites yet',
              style: isArabic
                  ? AppTextStyles.arabicTitleMedium
                  : AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? 'احفظ المنتجات التي تعجبك للوصول إليها لاحقاً.'
                  : 'Save products you love for later.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (onBrowse != null) ...[
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: onBrowse,
                child: Text(isArabic ? 'تصفح المنتجات' : 'Browse Products'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
