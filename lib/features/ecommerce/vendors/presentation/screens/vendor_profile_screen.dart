// Vendor profile — light design
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../features/home/presentation/providers/home_providers.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';

class VendorProfileScreen extends ConsumerWidget {
  const VendorProfileScreen({super.key, required this.vendorSlug});

  final String vendorSlug;

  IconData _productIcon(String id) {
    const icons = [
      Icons.spa_rounded,
      Icons.smartphone_rounded,
      Icons.shopping_bag_rounded,
      Icons.checkroom_rounded,
      Icons.diamond_rounded,
    ];
    return icons[id.hashCode.abs() % icons.length];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final home = ref.watch(homeDataProvider);
    final vendorName = ar ? 'متجر سوني الرسمي' : 'Sony Official Store';

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: vendorName,
            variant: KayanSectionHeroVariant.orange,
            leading: KayanHeroIconButton(
              icon: Icons.arrow_forward_ios_rounded,
              onTap: () => context.pop(),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text('4.8', style: KayanDesignTokens.cairo(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Row(
              children: [
                _VendorStat('1.2K', ar ? 'منتج' : 'Products', KayanDesignTokens.kBlue),
                _VendorStat('4.8', ar ? 'تقييم' : 'Rating', KayanDesignTokens.oOrange),
                _VendorStat('98%', ar ? 'رد سريع' : 'Response', KayanDesignTokens.kGreen),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                ar ? 'منتجات المتجر' : 'Store products',
                style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: home.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(
                child: Text(ar ? 'تعذّر التحميل' : 'Load failed', style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted)),
              ),
              data: (data) {
                final products = data.featuredProducts.take(8).toList();
                if (products.isEmpty) {
                  return Center(
                    child: Text(ar ? 'لا توجد منتجات' : 'No products', style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted)),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  children: products.map((product) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: KayanClassifiedAdCard(
                        title: ar ? product.nameAr : product.nameEn,
                        locationLine: ar ? 'شحن سريع' : 'Fast shipping',
                        priceLabel: '${product.price.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
                        icon: _productIcon(product.id),
                        accentGradient: KayanDesignTokens.gradOrange,
                        priceColor: KayanDesignTokens.oOrange,
                        onTap: () => context.push(AppRoutes.productPath(product.slug)),
                      ),
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

class _VendorStat extends StatelessWidget {
  const _VendorStat(this.value, this.label, this.color);

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
          border: Border.all(color: KayanDesignTokens.border),
          boxShadow: KayanDesignTokens.shadowS,
        ),
        child: Column(
          children: [
            Text(value, style: KayanDesignTokens.cairo(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 4),
            Text(label, style: KayanDesignTokens.cairo(fontSize: 11, color: KayanDesignTokens.muted)),
          ],
        ),
      ),
    );
  }
}
