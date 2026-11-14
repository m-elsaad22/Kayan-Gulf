// Super-app hub — matches design/html/07-dashboard-1.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, MediaQuery.paddingOf(context).top + 20, 24, 46),
            decoration: const BoxDecoration(gradient: KayanDesignTokens.gradHero),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    // Logo centered in row
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/kayan_icon.webp',
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.apps_rounded, color: Colors.white, size: 36),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'KAYAN',
                      style: KayanDesignTokens.cairo(
                          fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                    const Spacer(),
                    KayanHeroIconButton(
                      icon: Icons.notifications_none_rounded,
                      onTap: () => context.push(AppRoutes.notifications),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  ar ? 'مرحباً بك في' : 'Welcome to',
                  style: KayanDesignTokens.cairo(
                      fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.82)),
                ),
                Text(
                  ar ? 'كيان الخليج' : 'KAYAN Gulf',
                  style: KayanDesignTokens.cairo(
                      fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  ar ? 'اختر عالمك من منصة كيان الشاملة' : 'Choose your world inside the KAYAN super app',
                  style: KayanDesignTokens.cairo(
                      fontSize: 13.5, fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.82), height: 1.8),
                ),
              ],
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 100),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    KayanHubCard(
                      title: ar ? 'خدمات منزلية' : 'Home Services',
                      subtitle: ar
                          ? 'فنيون معتمدون — يصلون خلال ساعة، خصم 50% للعملاء الجدد'
                          : 'Certified technicians — arrive in an hour, 50% off for new users',
                      gradient: KayanDesignTokens.hubServices,
                      icon: Icons.home_repair_service_rounded,
                      illustrationIcon: Icons.handyman_rounded,
                      onTap: () => context.go(AppRoutes.services),
                    ),
                    KayanHubCard(
                      title: ar ? 'متجر تسوق' : 'Shopping Store',
                      subtitle: ar
                          ? 'آلاف المنتجات المختارة، عروض حصرية، وتوصيل سريع'
                          : 'Thousands of products, exclusive deals, and fast delivery',
                      gradient: KayanDesignTokens.hubShop,
                      icon: Icons.shopping_bag_rounded,
                      illustrationIcon: Icons.shopping_cart_checkout_rounded,
                      onTap: () => context.go(AppRoutes.shop),
                    ),
                    KayanHubCard(
                      title: ar ? 'إعلانات مبوبة' : 'Classifieds',
                      subtitle: ar
                          ? 'سيارات، عقارات، وظائف، وإلكترونيات في مدن الخليج'
                          : 'Cars, real estate, jobs, and electronics across the GCC',
                      gradient: KayanDesignTokens.hubClassifieds,
                      icon: Icons.apartment_rounded,
                      illustrationIcon: Icons.newspaper_rounded,
                      onTap: () => context.go(AppRoutes.classifieds),
                    ),
                    KayanHubCard(
                      title: ar ? 'توصيل سريع' : 'Fast Delivery',
                      subtitle: ar
                          ? 'توصيل فوري من مطاعمك ومتاجرك ومستودعاتك المفضلة'
                          : 'Instant delivery from restaurants, stores, and warehouses',
                      gradient: KayanDesignTokens.hubOrders,
                      icon: Icons.lunch_dining_rounded,
                      illustrationIcon: Icons.delivery_dining_rounded,
                      onTap: () => context.go(AppRoutes.delivery),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
