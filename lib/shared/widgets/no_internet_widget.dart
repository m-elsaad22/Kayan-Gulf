import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class NoInternetWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool isArabic;

  const NoInternetWidget({
    super.key,
    this.onRetry,
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
              Icons.wifi_off_rounded,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'لا يوجد اتصال' : 'No Internet',
              style: isArabic
                  ? AppTextStyles.arabicTitleMedium
                  : AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? 'تحقق من اتصالك وحاول مرة أخرى.'
                  : 'Check your connection and try again.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
