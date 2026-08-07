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
                Row(
                  children: [
                    Expanded(child: _DeliveryQuickChip(icon: Icons.receipt_long_rounded, label: ar ? 'طلباتي' : 'My orders', onTap: () => context.push(AppRoutes.deliveryMyOrders))),
                    const SizedBox(width: 8),
                    Expanded(child: _DeliveryQuickChip(icon: Icons.favorite_border_rounded, label: ar ? 'المفضلة' : 'Favorites', onTap: () => context.push(AppRoutes.deliveryFavorites))),
                    const SizedBox(width: 8),
                    Expanded(child: _DeliveryQuickChip(icon: Icons.local_offer_outlined, label: ar ? 'كوبونات' : 'Coupons', onTap: () => context.push(AppRoutes.deliveryCoupons))),
                  ],
                ),
                const SizedBox(height: 16),
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

class _DeliveryQuickChip extends StatelessWidget {
  const _DeliveryQuickChip({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: KayanDesignTokens.border),
          boxShadow: KayanDesignTokens.shadowS,
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: KayanDesignTokens.oOrange),
            const SizedBox(height: 4),
            Text(label, style: KayanDesignTokens.cairo(fontSize: 10, fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
