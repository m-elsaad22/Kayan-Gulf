// Product detail — light design (61-sh-product-details.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../features/home/data/models/home_models.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../product/data/models/product_models.dart';
import '../../../product/presentation/providers/product_providers.dart';

class ShopProductScreen extends ConsumerWidget {
  const ShopProductScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final productAsync = ref.watch(productDetailProvider(slug));

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(ar ? 'المنتج غير موجود' : 'Product not found')),
        data: (product) => _Body(product: product, ar: ar),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.product, required this.ar});

  final ProductDetailModel product;
  final bool ar;

  void _addToCart(WidgetRef ref) {
    ref.read(cartProvider.notifier).addItem(CartItemModel(
          cartItemId: 'ci-${DateTime.now().millisecondsSinceEpoch}',
          productId: product.id,
          slug: product.slug,
          nameAr: product.nameAr,
          nameEn: product.nameEn,
          imageUrl: product.images.isNotEmpty ? product.images.first.url : '',
          unitPrice: product.price,
          quantity: 1,
          maxStock: product.stock,
        ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final price = product.price;
    final hasDiscount = product.compareAtPrice != null && product.compareAtPrice! > product.price;

    return Column(
      children: [
        KayanSectionHero(
          title: ar ? product.nameAr : product.nameEn,
          variant: KayanSectionHeroVariant.orange,
          leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: KayanDesignTokens.gradOrange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.shopping_bag_rounded, size: 72, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                ar ? product.nameAr : product.nameEn,
                style: KayanDesignTokens.cairo(fontSize: 20, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${price.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
                    style: KayanDesignTokens.cairo(fontSize: 22, fontWeight: FontWeight.w900, color: KayanDesignTokens.oOrange),
                  ),
                  if (hasDiscount) ...[
                    const SizedBox(width: 10),
                    Text(
                      product.compareAtPrice!.toStringAsFixed(0),
                      style: KayanDesignTokens.cairo(fontSize: 14, color: KayanDesignTokens.muted).copyWith(decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 16, color: KayanDesignTokens.gold),
                  const SizedBox(width: 4),
                  Text('${product.rating.toStringAsFixed(1)} (${product.totalRatings})', style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.text2)),
                ],
              ),
              if ((product.descriptionAr ?? product.descriptionEn ?? '').isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  ar ? (product.descriptionAr ?? '') : (product.descriptionEn ?? product.descriptionAr ?? ''),
                  style: KayanDesignTokens.cairo(fontSize: 14, color: KayanDesignTokens.text2, height: 1.8),
                ),
              ],
              const SizedBox(height: 20),
              KayanCtaButton(
                label: ar ? 'أضف للسلة' : 'Add to cart',
                trailingIcon: Icons.add_shopping_cart_rounded,
                variant: KayanCtaVariant.orange,
                onPressed: () {
                  _addToCart(ref);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'أُضيف للسلة' : 'Added to cart'), behavior: SnackBarBehavior.floating),
                  );
                },
              ),
              const SizedBox(height: 10),
              KayanCtaButton(
                label: ar ? 'اشتري الآن' : 'Buy now',
                trailingIcon: Icons.flash_on_rounded,
                variant: KayanCtaVariant.blue,
                onPressed: () {
                  _addToCart(ref);
                  context.push(AppRoutes.shopCart);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
