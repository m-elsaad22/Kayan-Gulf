// Shop home — matches design/html/59-sh-dashboard.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../features/home/data/models/home_models.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../product/data/models/product_models.dart';
import '../../../product/presentation/providers/product_providers.dart';

const _shopCategories = [
  (Icons.checkroom_rounded, 'أزياء', 'Fashion'),
  (Icons.smartphone_rounded, 'إلكترونيات', 'Electronics'),
  (Icons.spa_rounded, 'عطور', 'Perfumes'),
  (Icons.diamond_rounded, 'مجوهرات', 'Jewelry'),
  (Icons.ice_skating_rounded, 'أحذية', 'Shoes'),
  (Icons.shopping_bag_rounded, 'حقائب', 'Bags'),
];

class ShopHomeScreen extends ConsumerWidget {
  const ShopHomeScreen({super.key});

  String _deliveryEta(ProductCardModel product, bool ar) {
    final day = product.id.hashCode.abs() % 3;
    return switch (day) {
      0 => ar ? 'توصيل غداً' : 'Delivery tomorrow',
      1 => ar ? 'توصيل يومين' : 'Delivery in 2 days',
      _ => ar ? 'توصيل ٣ أيام' : 'Delivery in 3 days',
    };
  }

  IconData _productIcon(ProductCardModel product) {
    final icons = [
      Icons.spa_rounded,
      Icons.smartphone_rounded,
      Icons.shopping_bag_rounded,
      Icons.checkroom_rounded,
      Icons.diamond_rounded,
    ];
    return icons[product.id.hashCode.abs() % icons.length];
  }

  void _quickAdd(WidgetRef ref, ProductCardModel product) {
    ref.read(cartProvider.notifier).addItem(CartItemModel(
          cartItemId: 'ci-${DateTime.now().millisecondsSinceEpoch}',
          productId: product.id,
          slug: product.slug,
          nameAr: product.nameAr,
          nameEn: product.nameEn,
          imageUrl: product.imageUrl,
          unitPrice: product.price,
          quantity: 1,
          maxStock: product.stock,
        ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final productsAsync = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'متجر كيان' : 'KAYAN Shop',
            variant: KayanSectionHeroVariant.orange,
            leading: KayanHeroIconButton(
              icon: Icons.arrow_forward_ios_rounded,
              onTap: () => context.go(AppRoutes.home),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                KayanHeroIconButton(
                  icon: Icons.shopping_cart_outlined,
                  onTap: () => context.push(AppRoutes.cart),
                ),
                const SizedBox(width: 8),
                KayanHeroIconButton(
                  icon: Icons.notifications_none_rounded,
                  onTap: () => context.push('${AppRoutes.shop}/notifications'),
                ),
              ],
            ),
            searchHint: ar ? 'ابحث عن منتج...' : 'Search for a product...',
            onSearchTap: () => context.push(AppRoutes.search),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 100),
              children: [
                KayanOfferBanner(
                  title: ar ? 'عروض حصرية حتى 35%' : 'Exclusive deals up to 35%',
                  subtitle: ar ? 'على تشكيلة الصيف الجديدة' : 'On the new summer collection',
                  gradient: KayanDesignTokens.gradOrange,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.push(AppRoutes.shopMyOrders),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: KayanDesignTokens.border),
                            boxShadow: KayanDesignTokens.shadowS,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.receipt_long_rounded, color: KayanDesignTokens.oOrange, size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: Text(ar ? 'طلباتي' : 'My orders', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, fontSize: 13))),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.push(AppRoutes.categories),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: KayanDesignTokens.border),
                            boxShadow: KayanDesignTokens.shadowS,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.grid_view_rounded, color: KayanDesignTokens.kBlue, size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: Text(ar ? 'الأقسام' : 'Categories', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, fontSize: 13))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                KayanCategoryPillRow(
                  isArabic: ar,
                  iconGradient: KayanDesignTokens.gradOrange,
                  items: _shopCategories
                      .map((c) => KayanCategoryPill(icon: c.$1, labelAr: c.$2, labelEn: c.$3))
                      .toList(),
                  onPillTap: (index) => context.push(AppRoutes.categories),
                ),
                const SizedBox(height: 24),
                KayanSectionHeader(
                  title: ar ? 'منتجات مقترحة لك' : 'Recommended for you',
                  action: ar ? 'عرض الكل' : 'See all',
                  actionColor: KayanDesignTokens.kOrange,
                  onAction: () => context.push(AppRoutes.shopBrowse),
                ),
                const SizedBox(height: 14),
                productsAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      ar ? 'تعذّر تحميل المنتجات' : 'Could not load products',
                      textAlign: TextAlign.center,
                      style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted),
                    ),
                  ),
                  data: (products) {
                    final featured = products.take(6).toList();
                    if (featured.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          ar ? 'لا توجد منتجات حالياً' : 'No products yet',
                          textAlign: TextAlign.center,
                          style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted),
                        ),
                      );
                    }
                    return Column(
                      children: featured.map((product) {
                        final reviews = product.reviewCount >= 1000
                            ? '${(product.reviewCount / 1000).toStringAsFixed(1)}K'
                            : '${product.reviewCount}';
                        return KayanServiceCard(
                          name: ar ? product.nameAr : product.nameEn,
                          rating: product.rating,
                          reviews: reviews,
                          duration: _deliveryEta(product, ar),
                          metaIcon: Icons.local_shipping_outlined,
                          priceLabel: '${product.price.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
                          priceColor: KayanDesignTokens.kOrange,
                          icon: _productIcon(product),
                          accentGradient: KayanDesignTokens.gradOrange,
                          onTap: () => context.push(AppRoutes.productPath(product.slug)),
                          onAdd: () => _quickAdd(ref, product),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.flashDeals),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: KayanDesignTokens.gradBlue,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: KayanDesignTokens.shadowS,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ar ? 'عروض البرق' : 'Flash deals',
                                style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                              Text(
                                ar ? 'خصومات محدودة الوقت' : 'Limited-time discounts',
                                style: KayanDesignTokens.cairo(fontSize: 12, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Colors.white70),
                      ],
                    ),
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
