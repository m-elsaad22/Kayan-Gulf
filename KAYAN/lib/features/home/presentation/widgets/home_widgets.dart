// ============================================================
// KAYAN — Home Screen Widgets
// lib/features/home/presentation/widgets/home_widgets.dart
//
// Contains all section widgets used inside HomeScreen:
//   • HeroBannerSlider
//   • SectionHeader
//   • CategoryGrid
//   • FlashDealSection
//   • FeaturedProductsRow
//   • FeaturedServicesRow
//   • RecentAdsRow
//   • RecommendationsRow
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/widgets/loaders/shimmer_loader.dart';
import '../../../../shared/widgets/cards/product_card.dart';
import '../../data/models/home_models.dart';

// ──────────────────────────────────────────────────────────────
// SECTION HEADER
// ──────────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String  titleAr;
  final String  titleEn;
  final String? seeAllRoute;
  final bool    isArabic;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.titleAr,
    required this.titleEn,
    this.seeAllRoute,
    required this.isArabic,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Gold left accent bar
          Container(
            width: 3, height: 18,
            decoration: BoxDecoration(
              gradient:     AppGradients.goldButton,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isArabic ? titleAr : titleEn,
            style: isArabic
                ? AppTextStyles.arabicTitleMedium
                : AppTextStyles.titleMedium,
          ),
          const Spacer(),
          if (trailing != null)
            trailing!
          else if (seeAllRoute != null)
            GestureDetector(
              onTap: () => context.push(seeAllRoute!),
              child: Row(
                children: [
                  Text(
                    isArabic ? 'عرض الكل' : 'See All',
                    style: AppTextStyles.seeAll,
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    isArabic
                        ? Icons.arrow_back_ios_rounded
                        : Icons.arrow_forward_ios_rounded,
                    size:  11,
                    color: AppColors.skyBlue,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// HERO BANNER SLIDER
// Auto-sliding with dot indicator and image overlay gradient
// ──────────────────────────────────────────────────────────────

class HeroBannerSlider extends StatefulWidget {
  final List<BannerModel> banners;
  final bool isArabic;

  const HeroBannerSlider({
    super.key,
    required this.banners,
    required this.isArabic,
  });

  @override
  State<HeroBannerSlider> createState() => _HeroBannerSliderState();
}

class _HeroBannerSliderState extends State<HeroBannerSlider> {
  final PageController _ctrl = PageController();
  int   _current = 0;
  Timer? _autoPlay;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlay = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || widget.banners.isEmpty) return;
      final next = (_current + 1) % widget.banners.length;
      _ctrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve:    Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoPlay?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const BannerShimmer();
    }

    return Column(
      children: [
        // Slides
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller:  _ctrl,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount:   widget.banners.length,
            itemBuilder: (_, i) => _BannerSlide(
              banner:   widget.banners[i],
              isArabic: widget.isArabic,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Dot indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.banners.length, (i) {
            final active = i == _current;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin:   const EdgeInsets.symmetric(horizontal: 3),
              width:    active ? 18 : 6,
              height:   6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: active
                    ? AppGradients.goldButton
                    : null,
                color: active ? null : AppColors.borderDefault,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _BannerSlide extends StatelessWidget {
  final BannerModel banner;
  final bool        isArabic;

  const _BannerSlide({required this.banner, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (banner.actionRoute != null) context.push(banner.actionRoute!);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
        child: ClipRRect(
          borderRadius: AppBorderRadius.card,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              CachedNetworkImage(
                imageUrl:    banner.imageUrl,
                fit:         BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.bgCard2),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.bgCard,
                  child: const Icon(
                    Icons.image_outlined,
                    color: AppColors.textMuted, size: 40,
                  ),
                ),
              ),

              // Gradient overlay
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppGradients.imageOverlayBottom,
                ),
              ),

              // Text content
              if (banner.titleAr != null || banner.titleEn != null)
                Positioned(
                  bottom: 16,
                  left:   16,
                  right:  16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (banner.titleAr != null || banner.titleEn != null)
                        Text(
                          isArabic
                              ? (banner.titleAr ?? banner.titleEn ?? '')
                              : (banner.titleEn ?? banner.titleAr ?? ''),
                          style: isArabic
                              ? AppTextStyles.arabicTitleLarge
                              : AppTextStyles.titleLarge,
                          maxLines: 1,
                        ),
                      if (banner.subtitleAr != null || banner.subtitleEn != null)
                        Text(
                          isArabic
                              ? (banner.subtitleAr ?? banner.subtitleEn ?? '')
                              : (banner.subtitleEn ?? banner.subtitleAr ?? ''),
                          style: (isArabic
                                  ? AppTextStyles.arabicBodySmall
                                  : AppTextStyles.bodySmall)
                              .copyWith(color: AppColors.silverLight),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// CATEGORY GRID (E-commerce or Services)
// ──────────────────────────────────────────────────────────────

class CategoryGrid extends StatelessWidget {
  final List<CategoryModel> categories;
  final bool                isArabic;
  final String              routePrefix; // '/shop' or '/services'

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.isArabic,
    required this.routePrefix,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding:         const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
        itemCount:       categories.length,
        itemBuilder:     (_, i) => _CategoryItem(
          category:    categories[i],
          isArabic:    isArabic,
          routePrefix: routePrefix,
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final bool          isArabic;
  final String        routePrefix;

  const _CategoryItem({
    required this.category,
    required this.isArabic,
    required this.routePrefix,
  });

  Color get _color {
    try {
      final hex = category.color ?? '#4169E1';
      return Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
    } catch (_) {
      return AppColors.royalBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.push('$routePrefix/categories/${category.slug}');
      },
      child: Container(
        width:  72,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width:    60, height: 60,
              decoration: BoxDecoration(
                color:        _color.withOpacity(0.12),
                borderRadius: AppBorderRadius.md,
                border:       Border.all(
                  color: _color.withOpacity(0.25), width: 1,
                ),
              ),
              child: category.iconUrl != null
                  ? ClipRRect(
                      borderRadius: AppBorderRadius.md,
                      child: CachedNetworkImage(
                        imageUrl: category.iconUrl!,
                        fit:      BoxFit.contain,
                        padding:  const EdgeInsets.all(10),
                      ),
                    )
                  : Center(
                      child: Text(
                        _emojiFor(category.slug),
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
            ),
            const SizedBox(height: 6),
            Text(
              isArabic ? category.nameAr : category.nameEn,
              style: (isArabic
                      ? AppTextStyles.arabicCaption
                      : AppTextStyles.caption)
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
              maxLines:  2,
              overflow:  TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _emojiFor(String slug) => switch (slug) {
    'electronics'  => '📱',
    'fashion'      => '👗',
    'home'         => '🏠',
    'beauty'       => '💄',
    'sports'       => '⚽',
    'toys'         => '🧸',
    'food'         => '🍕',
    'automotive'   => '🚗',
    'plumbing'     => '🔧',
    'electrical'   => '⚡',
    'ac'           => '❄️',
    'cleaning'     => '🧹',
    'painting'     => '🎨',
    'movers'       => '📦',
    _              => '🔷',
  };
}

// ──────────────────────────────────────────────────────────────
// FLASH DEAL SECTION
// Horizontal scroll with countdown timer per card
// ──────────────────────────────────────────────────────────────

class FlashDealSection extends StatelessWidget {
  final List<ProductCardModel> products;
  final bool                   isArabic;

  const FlashDealSection({
    super.key,
    required this.products,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      decoration: BoxDecoration(
        gradient:     AppGradients.flashDealCard,
        borderRadius: AppBorderRadius.card,
        border:       Border.all(
          color: AppColors.error.withOpacity(0.2), width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header inside the red card
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.md, AppSpacing.md, 0,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:        AppColors.badgeSale,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Text('⚡', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        isArabic ? 'صفقات اليوم' : 'Flash Deals',
                        style: AppTextStyles.badgeMedium,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.flashDeals),
                  child: Text(
                    isArabic ? 'عرض الكل' : 'See All',
                    style: AppTextStyles.seeAll.copyWith(
                      color: AppColors.errorLight,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Products scroll
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:         const EdgeInsets.only(
                left: AppSpacing.md, right: AppSpacing.md, bottom: AppSpacing.md,
              ),
              itemCount:   products.length,
              itemBuilder: (_, i) => Padding(
                padding: EdgeInsets.only(right: i < products.length - 1 ? 10 : 0),
                child: SizedBox(
                  width: 150,
                  child: ProductCard(
                    product:   products[i],
                    showTimer: true,
                    onTap: () => context.push(
                      AppRoutes.productPath(products[i].slug),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// HORIZONTAL PRODUCTS ROW (Featured / Recommendations)
// ──────────────────────────────────────────────────────────────

class HorizontalProductsRow extends StatelessWidget {
  final List<ProductCardModel> products;
  final bool                   isArabic;

  const HorizontalProductsRow({
    super.key,
    required this.products,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding:         const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding,
        ),
        itemCount:   products.length,
        itemBuilder: (_, i) => Padding(
          padding: EdgeInsets.only(right: i < products.length - 1 ? 12 : 0),
          child:   SizedBox(
            width: 158,
            child: ProductCard(
              product: products[i],
              onTap:   () => context.push(
                AppRoutes.productPath(products[i].slug),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// FEATURED SERVICES ROW
// ──────────────────────────────────────────────────────────────

class FeaturedServicesRow extends StatelessWidget {
  final List<ServiceCardModel> services;
  final bool                   isArabic;

  const FeaturedServicesRow({
    super.key,
    required this.services,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding:         const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding,
        ),
        itemCount:   services.length,
        itemBuilder: (_, i) => _ServiceCard(
          service:  services[i],
          isArabic: isArabic,
          onTap:    () => context.push(
            AppRoutes.servicePath(services[i].slug),
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceCardModel service;
  final bool             isArabic;
  final VoidCallback     onTap;

  const _ServiceCard({
    required this.service,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width:  160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color:        AppColors.bgCard,
          borderRadius: AppBorderRadius.card,
          border:       Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppBorderRadius.card.topLeft.x),
              ),
              child: SizedBox(
                height: 95, width: double.infinity,
                child: service.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl:    service.imageUrl!,
                        fit:         BoxFit.cover,
                        placeholder: (_, __) => const ShimmerBox(
                          width: double.infinity, height: 95,
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.bgCard2,
                          child: const Icon(Icons.build_outlined,
                              color: AppColors.textMuted),
                        ),
                      )
                    : Container(
                        color: AppColors.bgCard2,
                        child: const Icon(Icons.build_outlined,
                            color: AppColors.textMuted, size: 32),
                      ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (service.categoryNameAr != null)
                    Text(
                      isArabic ? service.categoryNameAr! : service.nameEn,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.skyBlue,
                      ),
                    ),
                  Text(
                    isArabic ? service.nameAr : service.nameEn,
                    style: isArabic
                        ? AppTextStyles.arabicBodySmall
                            .copyWith(fontWeight: FontWeight.w600)
                        : AppTextStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'من ${service.basePrice.toInt()} ر.س',
                        style: AppTextStyles.priceSmall,
                      ),
                      const Spacer(),
                      const Icon(Icons.star_rounded,
                          size: 11, color: AppColors.starFilled),
                      const SizedBox(width: 2),
                      Text(
                        service.rating.toStringAsFixed(1),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// RECENT ADS ROW
// ──────────────────────────────────────────────────────────────

class RecentAdsRow extends StatelessWidget {
  final List<AdCardModel> ads;
  final bool              isArabic;

  const RecentAdsRow({
    super.key,
    required this.ads,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding:         const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding,
        ),
        itemCount:   ads.length,
        itemBuilder: (_, i) => _AdCard(
          ad:       ads[i],
          isArabic: isArabic,
          onTap:    () => context.push(AppRoutes.adPath(ads[i].slug)),
        ),
      ),
    );
  }
}

class _AdCard extends StatelessWidget {
  final AdCardModel  ad;
  final bool         isArabic;
  final VoidCallback onTap;

  const _AdCard({
    required this.ad,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width:  150,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color:        AppColors.bgCard,
          borderRadius: AppBorderRadius.card,
          border:       Border.all(
            color: ad.isBoosted
                ? AppColors.borderGold
                : AppColors.borderSubtle,
          ),
          boxShadow: ad.isBoosted ? [
            BoxShadow(
              color:      AppColors.metallicGold.withOpacity(0.1),
              blurRadius: 10,
            ),
          ] : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppBorderRadius.card.topLeft.x),
              ),
              child: SizedBox(
                height: 95, width: double.infinity,
                child: ad.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl:    ad.imageUrl!,
                        fit:         BoxFit.cover,
                        placeholder: (_, __) => const ShimmerBox(
                          width: double.infinity, height: 95,
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.bgCard2,
                          child: const Icon(Icons.image_outlined,
                              color: AppColors.textMuted),
                        ),
                      )
                    : Container(color: AppColors.bgCard2,
                        child: const Icon(Icons.image_outlined,
                            color: AppColors.textMuted)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ad.isBoosted)
                    Container(
                      margin: const EdgeInsets.only(bottom: 3),
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color:        AppColors.metallicGold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('مميز ⭐',
                          style: AppTextStyles.badge.copyWith(
                              color: AppColors.metallicGold)),
                    ),
                  Text(
                    ad.title,
                    style: isArabic
                        ? AppTextStyles.arabicBodySmall
                            .copyWith(fontWeight: FontWeight.w600)
                        : AppTextStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (ad.price != null)
                    Text(
                      '${ad.price!.toInt()} ر.س',
                      style: AppTextStyles.priceSmall,
                    )
                  else
                    Text(
                      isArabic ? 'مجاني' : 'Free',
                      style: AppTextStyles.priceSmall.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 10, color: AppColors.textMuted),
                      const SizedBox(width: 2),
                      Text(ad.city,
                          style: AppTextStyles.caption.copyWith(
                              color: AppColors.textMuted)),
                      const Spacer(),
                      Text(ad.timeAgo,
                          style: AppTextStyles.caption.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 9)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// EMERGENCY SERVICES STRIP
// ──────────────────────────────────────────────────────────────

class EmergencyStrip extends StatelessWidget {
  final bool isArabic;

  const EmergencyStrip({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('${AppRoutes.services}/categories?emergency=true'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          gradient:     AppGradients.emergency,
          borderRadius: AppBorderRadius.md,
          boxShadow: [
            BoxShadow(
              color:      AppColors.error.withOpacity(0.3),
              blurRadius: 16,
              offset:     const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Text('🚨', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'خدمة طوارئ ٢٤/٧' : '24/7 Emergency Service',
                    style: isArabic
                        ? AppTextStyles.arabicTitleSmall
                        : AppTextStyles.titleSmall,
                  ),
                  Text(
                    isArabic
                        ? 'فنيون يصلون إليك في أسرع وقت'
                        : 'Technicians reach you ASAP',
                    style: (isArabic
                            ? AppTextStyles.arabicBodySmall
                            : AppTextStyles.bodySmall)
                        .copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Icon(
              isArabic
                  ? Icons.arrow_back_ios_rounded
                  : Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size:  16,
            ),
          ],
        ),
      ),
    );
  }
}
