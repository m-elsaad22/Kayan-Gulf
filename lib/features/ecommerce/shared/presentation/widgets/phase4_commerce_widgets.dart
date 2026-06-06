// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_border_radius.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_gradients.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

class Phase4CommerceScaffold extends StatelessWidget {
  final String titleAr;
  final String titleEn;
  final String subtitleAr;
  final String subtitleEn;
  final List<Widget> children;

  const Phase4CommerceScaffold({
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
        decoration: const BoxDecoration(gradient: AppGradients.heroDiagonal),
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

class Phase4CommerceCard extends StatelessWidget {
  final IconData icon;
  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final Color color;

  const Phase4CommerceCard({
    super.key,
    required this.icon,
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    this.color = AppColors.royalBlue,
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
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: AppBorderRadius.md,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? titleAr : titleEn,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic ? bodyAr : bodyEn,
                  style: AppTextStyles.bodySmall.copyWith(
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
