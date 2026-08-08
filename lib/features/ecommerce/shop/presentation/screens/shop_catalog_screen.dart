// Product catalog — light design (60-sh-product-list.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../product/presentation/providers/product_providers.dart';

class ShopCatalogScreen extends ConsumerWidget {
  const ShopCatalogScreen({super.key, this.categorySlug});

  final String? categorySlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final productsAsync = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'المنتجات' : 'Products',
            variant: KayanSectionHeroVariant.orange,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
            trailing: KayanHeroIconButton(icon: Icons.shopping_cart_outlined, onTap: () => context.push(AppRoutes.shopCart)),
          ),
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(child: Text(ar ? 'تعذّر التحميل' : 'Load failed', style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted))),
              data: (products) {
                final list = products;
                if (list.isEmpty) {
                  return Center(child: Text(ar ? 'لا توجد منتجات' : 'No products', style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted)));
                }
                return ListView(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                  children: list.map((p) {
                    return KayanClassifiedAdCard(
                      title: ar ? p.nameAr : p.nameEn,
                      locationLine: ar ? 'توصيل سريع' : 'Fast delivery',
                      priceLabel: '${p.price.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
                      icon: Icons.shopping_bag_rounded,
                      isFeatured: p.originalPrice != null,
                      featuredLabel: ar ? 'عرض' : 'Sale',
                      onTap: () => context.push(AppRoutes.productPath(p.slug)),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
