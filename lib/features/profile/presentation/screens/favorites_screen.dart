// KAYAN — Favorites Screen
// lib/features/profile/presentation/screens/favorites_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../ecommerce/product/presentation/providers/product_providers.dart';
import '../../../ecommerce/product/data/models/product_models.dart';
import '../../../../shared/widgets/cards/product_card.dart';
import '../../../../shared/widgets/loaders/shimmer_loader.dart';
import '../../../../features/home/data/models/home_models.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar        = ref.watch(isArabicProvider);
    final favIds    = ref.watch(favoritesProvider);
    final products  = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface, centerTitle: true,
        title: Text(ar ? 'المفضلة' : 'Favorites', style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
        leading: IconButton(icon: Icon(ar ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
        actions: [
          if (favIds.isNotEmpty) TextButton(
            onPressed: () => ref.read(favoritesProvider.notifier).state = {},
            child: Text(ar ? 'مسح الكل' : 'Clear All', style: AppTextStyles.labelLarge.copyWith(color: AppColors.error))),
        ],
      ),
      body: products.when(
        loading: () => GridView.count(crossAxisCount: 2, shrinkWrap: true, padding: const EdgeInsets.all(16),
            crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.65,
            children: List.generate(4, (_) => const ProductCardShimmer())),
        error: (_, __) => Center(child: Text(ar ? 'حدث خطأ' : 'Error')),
        data: (all) {
          final favs = all.where((p) => favIds.contains(p.id)).toList();
          if (favs.isEmpty) {
            return Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.favorite_border_rounded, size: 72, color: AppColors.textMuted),
              const SizedBox(height: 20),
              Text(ar ? 'لا توجد منتجات في المفضلة' : 'No favorites yet', style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              Text(ar ? 'أضف المنتجات التي تعجبك للمفضلة' : 'Add products you love to favorites', style: (ar ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              GestureDetector(onTap: () => context.push(AppRoutes.shop), child: Container(padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
                decoration: BoxDecoration(gradient: AppGradients.primaryButton, borderRadius: AppBorderRadius.button,
                    boxShadow: [BoxShadow(color: AppColors.royalBlue.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 4))]),
                child: Text(ar ? 'استعرض المنتجات' : 'Browse Products', style: ar ? AppTextStyles.arabicButton : AppTextStyles.buttonMedium))),
            ])));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.65),
            itemCount: favs.length,
            itemBuilder: (_, i) => ProductCard(
              product:     favs[i],
              isFavorited: true,
              onTap:       () => context.push(AppRoutes.productPath(favs[i].slug)),
              onFavorite:  () => ref.read(favoritesProvider.notifier).update((s) {
                final n = {...s}; n.remove(favs[i].id); return n;
              }),
            ),
          );
        },
      ),
    );
  }
}
