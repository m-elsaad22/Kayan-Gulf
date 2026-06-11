// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/luxury/luxury_widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(isArabicProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppGradients.splash
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.lightBg, AppColors.lightCardBg],
                ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'أهلاً بك في كيان' : 'Welcome to KAYAN',
                            style: isArabic
                                ? AppTextStyles.arabicHeadlineMedium
                                : AppTextStyles.headlineMedium,
                          ),
                          const SizedBox(height: 6),
                          LuxuryGlassPanel(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            blurSigma: 12,
                            child: Text(
                              isArabic ? 'سوبر أب الخليج' : 'GCC Super App',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.metallicGold,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    LuxuryTap(
                      onTap: () {
                        context.push(AppRoutes.profile);
                      },
                      child: LuxuryGlassPanel(
                        padding: EdgeInsets.zero,
                        blurSigma: 14,
                        borderRadius: BorderRadius.circular(24),
                        child: const SizedBox(
                          width: 48,
                          height: 48,
                          child: Icon(Icons.account_circle_rounded, size: 28),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  isArabic
                      ? 'اختر عالمك الآن من منصة كيان الشاملة'
                      : 'Choose your world inside the KAYAN super app',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.darkSubtext
                        : AppColors.lightSubtext,
                  ),
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    children: [
                      LuxuryHubCard(
                        icon: Icons.home_repair_service_rounded,
                        title: isArabic ? 'خدمات منزلية' : 'Home Services',
                        subtitle: isArabic
                            ? 'فنيون موثوقون وحجوزات فورية'
                            : 'Trusted providers and instant bookings',
                        gradient: AppGradients.primaryButton,
                        onTap: () => context.go(AppRoutes.services),
                      ),
                      const SizedBox(height: 16),
                      LuxuryHubCard(
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
                      LuxuryHubCard(
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
