// KAYAN — Vendor Profile Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_gradients.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_border_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/cards/product_card.dart';
import '../../../../../features/home/presentation/providers/home_providers.dart';

class VendorProfileScreen extends ConsumerWidget {
  final String vendorSlug;
  const VendorProfileScreen({super.key, required this.vendorSlug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar   = ref.watch(isArabicProvider);
    final home = ref.watch(homeDataProvider);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 180, pinned: true,
          backgroundColor: AppColors.bgSurface,
          leading: GestureDetector(onTap: () => context.pop(), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.bgCard.withOpacity(0.9), shape: BoxShape.circle), child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18))),
          flexibleSpace: FlexibleSpaceBar(background: Container(
            decoration: const BoxDecoration(gradient: AppGradients.hero),
            child: SafeArea(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 48),
              Container(width: 72, height: 72, decoration: BoxDecoration(gradient: AppGradients.primaryButton, shape: BoxShape.circle, border: Border.all(color: AppColors.metallicGold, width: 2)),
                  child: const Center(child: Text('🏪', style: TextStyle(fontSize: 30)))),
              const SizedBox(height: 8),
              const Text('متجر سوني الرسمي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.star_rounded, size: 13, color: AppColors.starFilled),
                const Text(' 4.8', style: TextStyle(fontSize: 12, color: Colors.white70)),
                const Text(' · 1,240 منتج', style: TextStyle(fontSize: 11, color: Colors.white54)),
              ]),
            ])),
          )),
        ),
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(AppSpacing.pagePadding), child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _VendorStat('1.2K', ar ? 'منتج' : 'Products', AppColors.royalBlue),
            _VendorStat('4.8', ar ? 'تقييم' : 'Rating', AppColors.metallicGold),
            _VendorStat('98%', ar ? 'رد سريع' : 'Response', AppColors.success),
          ]),
          const SizedBox(height: 20),
          Align(alignment: isArabic(ar) ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(ar ? 'منتجات المتجر' : 'Store Products', style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium)),
          const SizedBox(height: 12),
        ]))),
        home.when(
          loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
          error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          data: (data) => SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            sliver: SliverGrid(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:12,mainAxisSpacing:12,childAspectRatio:0.65),
              delegate: SliverChildBuilderDelegate((_, i) => ProductCard(product: data.featuredProducts[i % data.featuredProducts.length], onTap: () => context.push(AppRoutes.productPath(data.featuredProducts[i % data.featuredProducts.length].slug))),
                  childCount: 8)),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ]),
    );
  }

  bool isArabic(bool ar) => ar;
}

Widget _VendorStat(String v, String l, Color c) => Column(children: [
  Text(v, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: c)),
  Text(l, style: AppTextStyles.caption),
]);
