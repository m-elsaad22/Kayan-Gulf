// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class Phase2WalletScaffold extends StatelessWidget {
  final String titleAr;
  final String titleEn;
  final String subtitleAr;
  final String subtitleEn;
  final List<Widget> children;

  const Phase2WalletScaffold({
    super.key,
    required this.titleAr,
    required this.titleEn,
    required this.subtitleAr,
    required this.subtitleEn,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(title: Text(isArabic ? titleAr : titleEn)),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.cardPremium),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          children: [
            Text(
              isArabic ? titleAr : titleEn,
              style: isArabic
                  ? AppTextStyles.arabicHeadlineSmall
                  : AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              isArabic ? subtitleAr : subtitleEn,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}

class Phase2WalletCard extends StatelessWidget {
  final IconData icon;
  final String titleAr;
  final String titleEn;
  final String value;
  final String captionAr;
  final String captionEn;

  const Phase2WalletCard({
    super.key,
    required this.icon,
    required this.titleAr,
    required this.titleEn,
    required this.value,
    required this.captionAr,
    required this.captionEn,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppBorderRadius.card,
        border: Border.all(color: AppColors.borderGold),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.metallicGold, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isArabic ? titleAr : titleEn, style: AppTextStyles.titleSmall),
                const SizedBox(height: 4),
                Text(value, style: AppTextStyles.priceMedium),
                const SizedBox(height: 4),
                Text(
                  isArabic ? captionAr : captionEn,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
