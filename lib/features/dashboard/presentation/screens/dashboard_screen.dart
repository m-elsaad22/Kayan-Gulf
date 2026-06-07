// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.hero),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isArabic ? 'أهلاً بك في كيان' : 'Welcome to KAYAN',
                        style: isArabic
                            ? AppTextStyles.arabicHeadlineMedium
                            : AppTextStyles.headlineMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.push(AppRoutes.profile),
                      icon: const Icon(Icons.account_circle_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isArabic
                      ? 'اختر عالمك الآن من منصة كيان الشاملة'
                      : 'Choose your world inside the KAYAN super app',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _DashboardCard(
                        icon: Icons.home_repair_service_rounded,
                        title: isArabic ? 'خدمات منزلية' : 'Home Services',
                        subtitle: isArabic
                            ? 'فنيون موثوقون وحجوزات فورية'
                            : 'Trusted providers and instant bookings',
                        gradient: AppGradients.primaryButton,
                        onTap: () => context.go(AppRoutes.services),
                      ),
                      const SizedBox(height: 16),
                      _DashboardCard(
                        icon: Icons.storefront_rounded,
                        title: isArabic ? 'متجر تسوق' : 'Shopping Store',
                        subtitle: isArabic
                            ? 'منتجات مختارة وتجربة شراء فاخرة'
                            : 'Curated products with premium checkout',
                        gradient: AppGradients.goldButton,
                        darkText: true,
                        onTap: () => context.go(AppRoutes.shop),
                      ),
                      const SizedBox(height: 16),
                      _DashboardCard(
                        icon: Icons.campaign_rounded,
                        title: isArabic ? 'إعلانات مبوبة' : 'Classifieds',
                        subtitle: isArabic
                            ? 'بيع وشراء بثقة في مدن الخليج'
                            : 'Buy and sell trusted listings across the GCC',
                        gradient: AppGradients.card,
                        onTap: () => context.go(AppRoutes.classifieds),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final bool darkText;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
    this.darkText = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg = darkText ? AppColors.bgPrimary : AppColors.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 150),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: AppBorderRadius.card,
          border: Border.all(color: AppColors.whiteOp(0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.24),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.whiteOp(darkText ? 0.22 : 0.12),
                borderRadius: AppBorderRadius.md,
              ),
              child: Icon(icon, color: fg, size: 34),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: fg.withOpacity(0.78),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: fg, size: 18),
          ],
        ),
      ),
    );
  }
}
