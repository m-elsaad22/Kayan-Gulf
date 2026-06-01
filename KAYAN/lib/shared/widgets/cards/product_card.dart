// ============================================================
// KAYAN — Product Card Widget
// lib/shared/widgets/cards/product_card.dart
//
// Used on: Home (recommendations, featured, flash deals),
//          Search results, Category products, Vendor page
// Variants: grid (default), horizontal (list mode)
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_border_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../features/home/data/models/home_models.dart';
import '../widgets/loaders/shimmer_loader.dart';

class ProductCard extends StatefulWidget {
  final ProductCardModel product;
  final bool             isHorizontal;  // horizontal list variant
  final bool             showTimer;     // show flash deal countdown
  final VoidCallback?    onTap;
  final VoidCallback?    onFavorite;
  final bool             isFavorited;

  const ProductCard({
    super.key,
    required this.product,
    this.isHorizontal = false,
    this.showTimer    = false,
    this.onTap,
    this.onFavorite,
    this.isFavorited  = false,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {

  late final AnimationController _pressCtrl;
  late final Animation<double>   _pressScale;

  // Flash deal countdown
  Timer?    _timer;
  Duration  _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();

    _pressCtrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 120),
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.96)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_pressCtrl);

    if (widget.showTimer && widget.product.flashDealEndsAt != null) {
      _updateRemaining();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) _updateRemaining();
      });
    }
  }

  void _updateRemaining() {
    final end = widget.product.flashDealEndsAt!;
    final now = DateTime.now();
    setState(() {
      _remaining = end.isAfter(now) ? end.difference(now) : Duration.zero;
    });
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String get _timerText {
    final h = _remaining.inHours;
    final m = _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isHorizontal
        ? _buildHorizontal()
        : _buildGrid();
  }

  // ──────────────────────────────────────────────────────────
  // GRID VARIANT (default — 2 per row)
  // ──────────────────────────────────────────────────────────
  Widget _buildGrid() {
    final product = widget.product;
    final discount = product.discountPercent;

    return GestureDetector(
      onTapDown:   (_) => _pressCtrl.forward(),
      onTapUp:     (_) { _pressCtrl.reverse(); _handleTap(); },
      onTapCancel: ()  => _pressCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _pressScale,
        builder: (_, child) => Transform.scale(
          scale: _pressScale.value,
          child: child,
        ),
        child: Container(
          decoration: BoxDecoration(
            color:        AppColors.bgCard,
            borderRadius: AppBorderRadius.card,
            border:       Border.all(color: AppColors.borderSubtle),
            boxShadow: [
              BoxShadow(
                color:      Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset:     const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image ──────────────────────────────────
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppBorderRadius.card.topLeft.x),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: product.imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl:    product.imageUrl!,
                              fit:         BoxFit.cover,
                              placeholder: (_, __) => const ShimmerBox(
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              errorWidget: (_, __, ___) => Container(
                                color:  AppColors.bgCard2,
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: AppColors.textMuted,
                                  size:  40,
                                ),
                              ),
                            )
                          : Container(
                              color: AppColors.bgCard2,
                              child: const Icon(
                                Icons.shopping_bag_outlined,
                                color: AppColors.textMuted,
                                size: 40,
                              ),
                            ),
                    ),
                  ),

                  // Discount badge
                  if (discount > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color:        AppColors.badgeSale,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '-${discount.toInt()}%',
                          style: AppTextStyles.badge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  // Flash deal timer
                  if (widget.showTimer && _remaining > Duration.zero)
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: const BoxDecoration(
                          gradient: AppGradients.flashDeal,
                        ),
                        child: Center(
                          child: Text(
                            '⏱ $_timerText',
                            style: AppTextStyles.countdownSmall,
                          ),
                        ),
                      ),
                    ),

                  // Favorite button
                  Positioned(
                    top: 6, right: 6,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        widget.onFavorite?.call();
                      },
                      child: Container(
                        width:  32, height: 32,
                        decoration: BoxDecoration(
                          color:        AppColors.bgModal.withOpacity(0.8),
                          shape:        BoxShape.circle,
                        ),
                        child: Icon(
                          widget.isFavorited
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size:  16,
                          color: widget.isFavorited
                              ? AppColors.error
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),

                  // Out of stock overlay
                  if (product.isOutOfStock)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppBorderRadius.card.topLeft.x),
                        ),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:        AppColors.bgCard2,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'نفد المخزون',
                                style: AppTextStyles.badgeMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // ── Info ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      product.nameAr,
                      style: AppTextStyles.arabicBodyMedium.copyWith(
                        fontSize: 12,
                        height:   1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Rating row
                    if (product.reviewCount > 0)
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 12, color: AppColors.starFilled,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '(${product.reviewCount})',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 6),

                    // Price row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.originalPrice != null)
                                Text(
                                  '${product.originalPrice!.toInt()} ر.س',
                                  style: AppTextStyles.priceOriginal,
                                ),
                              Text(
                                '${product.price.toInt()} ر.س',
                                style: AppTextStyles.priceMedium,
                              ),
                            ],
                          ),
                        ),
                        // Add to cart mini button
                        GestureDetector(
                          onTap: () => HapticFeedback.lightImpact(),
                          child: Container(
                            width:  28, height: 28,
                            decoration: BoxDecoration(
                              gradient:     AppGradients.primaryButton,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              size: 16, color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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

  // ──────────────────────────────────────────────────────────
  // HORIZONTAL VARIANT (list mode)
  // ──────────────────────────────────────────────────────────
  Widget _buildHorizontal() {
    final product = widget.product;

    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        height:      110,
        decoration:  BoxDecoration(
          color:        AppColors.bgCard,
          borderRadius: AppBorderRadius.md,
          border:       Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(AppBorderRadius.md.topLeft.x),
              ),
              child: SizedBox(
                width: 100,
                child: product.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl:    product.imageUrl!,
                        fit:         BoxFit.cover,
                        placeholder: (_, __) => const ShimmerBox(
                          width: 100, height: double.infinity),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.bgCard2,
                          child: const Icon(Icons.image_not_supported_outlined,
                              color: AppColors.textMuted),
                        ),
                      )
                    : Container(
                        color: AppColors.bgCard2,
                        child: const Icon(Icons.shopping_bag_outlined,
                            color: AppColors.textMuted),
                      ),
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:  MainAxisAlignment.center,
                  children: [
                    Text(
                      product.nameAr,
                      style:    AppTextStyles.arabicTitleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (product.vendorName != null)
                      Text(
                        product.vendorName!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '${product.price.toInt()} ر.س',
                          style: AppTextStyles.priceMedium,
                        ),
                        if (product.originalPrice != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            '${product.originalPrice!.toInt()} ر.س',
                            style: AppTextStyles.priceOriginal,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Favorite
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Icon(
                widget.isFavorited
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size:  18,
                color: widget.isFavorited
                    ? AppColors.error
                    : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
