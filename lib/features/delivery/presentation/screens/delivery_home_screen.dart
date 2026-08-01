import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../data/mock/delivery_mock_data.dart';
import '../providers/delivery_providers.dart';

/// Matches design/html/92-or-dashboard.html
class DeliveryHomeScreen extends ConsumerWidget {
  const DeliveryHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final vendors = ref.watch(deliveryVendorsProvider);
    final cartCount = ref.watch(deliveryCartCountProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'طلبات' : 'Orders',
            variant: KayanSectionHeroVariant.redOrange,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    KayanHeroIconButton(
                      icon: Icons.shopping_cart_outlined,
                      onTap: () => context.push(AppRoutes.deliveryCart),
                    ),
                    if (cartCount > 0)
                      Positioned(
                        top: -2,
                        left: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Text(
                            '$cartCount',
                            style: KayanDesignTokens.cairo(fontSize: 9, fontWeight: FontWeight.w800, color: KayanDesignTokens.oOrange),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                KayanHeroIconButton(
                  icon: Icons.notifications_none_rounded,
                  onTap: () => context.push(AppRoutes.notifications),
                ),
              ],
            ),
            searchHint: ar ? 'ابحث عن مطعم أو منتج...' : 'Search restaurants or products...',
            onSearchTap: () => context.push(AppRoutes.deliveryVendors),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 100),
              children: [
                KayanOfferBanner(
                  title: ar ? 'خصم 30% على أول طلب' : '30% off your first order',
                  subtitle: ar ? 'توصيل مجاني لأول 3 طلبات' : 'Free delivery on your first 3 orders',
                ),
                KayanCategoryPillRow(
                  isArabic: ar,
                  items: deliveryCategories
                      .map((c) => KayanCategoryPill(icon: c.icon, labelAr: c.nameAr, labelEn: c.nameEn))
                      .toList(),
                ),
                const SizedBox(height: 24),
                KayanSectionHeader(
                  title: ar ? 'الأكثر طلباً بالقرب منك' : 'Popular near you',
                  action: ar ? 'عرض الكل' : 'See all',
                  onAction: () => context.push(AppRoutes.deliveryVendors),
                ),
                const SizedBox(height: 14),
                ...vendors.map(
                  (v) => KayanVendorCard(
                    name: v.name(ar),
                    rating: v.rating,
                    reviews: v.reviewCount,
                    eta: v.eta(ar),
                    isOpen: v.isOpen,
                    deliveryLabel: v.deliveryFee(ar),
                    icon: v.icon,
                    onTap: () => context.push(AppRoutes.deliveryVendorPath(v.slug)),
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
