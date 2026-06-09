import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/widgets/kayan_themed_scaffold.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../shared/providers/locale_provider.dart';

/// KAYAN Screen — Contact Seller
class ContactSellerScreen extends ConsumerWidget {
  const ContactSellerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(isArabicProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return KayanThemedScaffold(
      titleAr: 'تواصل مع البائع',
      titleEn: 'Contact Seller',
      body: ListView(
        children: [
          Icon(Icons.layers_outlined, size: 64, color: isDark ? AppColors.skyBlue : AppColors.pepsiBlue),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'تواصل مع البائع' : 'Contact Seller',
            style: isArabic ? AppTextStyles.arabicHeadlineSmall : AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'شاشة كيان — تجربة احترافية مع دعم الوضع الفاتح/الداكن والعربية/الإنجليزية.'
                : 'KAYAN screen with light/dark mode and Arabic/English support.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.darkSubtext : AppColors.lightSubtext,
            ),
          ),
        ],
      ),
    );
  }
}
