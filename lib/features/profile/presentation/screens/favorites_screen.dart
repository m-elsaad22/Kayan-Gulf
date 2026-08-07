// Favorites — light design (17-wishlist)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../ecommerce/product/presentation/providers/product_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final favIds = ref.watch(favoritesProvider);
    final productsAsync = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'المفضلة' : 'Favorites',
            variant: KayanSectionHeroVariant.blue,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
          ),
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(child: Text(ar ? 'حدث خطأ' : 'Error')),
              data: (all) {
                final favs = all.where((p) => favIds.contains(p.id)).toList();
                if (favs.isEmpty) {
                  return Center(child: Text(ar ? 'لا توجد عناصر مفضلة' : 'No favorites yet', style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted)));
                }
                return ListView(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                  children: favs.map((p) {
                    return KayanClassifiedAdCard(
                      title: ar ? p.nameAr : p.nameEn,
                      locationLine: ar ? 'متجر كيان' : 'KAYAN Shop',
                      priceLabel: '${p.price.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
                      icon: Icons.favorite_rounded,
                      isFavorited: true,
                      onTap: () => context.push(AppRoutes.productPath(p.slug)),
                      onFavorite: () {
                        final next = Set<String>.from(favIds)..remove(p.id);
                        ref.read(favoritesProvider.notifier).state = next;
                      },
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
