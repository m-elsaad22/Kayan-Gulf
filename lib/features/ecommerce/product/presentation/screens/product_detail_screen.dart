// ============================================================
// KAYAN — Product Detail Screen
// lib/features/ecommerce/product/presentation/screens/product_detail_screen.dart
//
// Layout (SliverAppBar + CustomScrollView):
//   1. Photo gallery (PageView + dot indicator)
//   2. Title, vendor, rating summary
//   3. Price section (current + original + discount %)
//   4. Color / Size / Model variant selectors
//   5. Delivery info strip
//   6. Description (expandable)
//   7. Rating breakdown (star bars)
//   8. Reviews list (3 shown, See All)
//   9. Upsells horizontal row
//   10. Sticky bottom: Quantity + Add to Cart + Buy Now
// ============================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_gradients.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_border_radius.dart';
import '../../../../../core/theme/screen_theme.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/loaders/shimmer_loader.dart';
import '../providers/product_providers.dart';
import '../../data/models/product_models.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String slug;
  const ProductDetailScreen({super.key, required this.slug});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final PageController _galleryCtrl = PageController();
  int  _galleryIndex = 0;
  int  _quantity     = 1;
  bool _descExpanded = false;
  bool _addedToCart  = false;

  @override
  void dispose() {
    _galleryCtrl.dispose();
    super.dispose();
  }

  void _addToCart(ProductDetailModel product) {
    HapticFeedback.heavyImpact();
    final selected = ref.read(selectedVariantsProvider);
    ref.read(cartProvider.notifier).addItem(CartItemModel(
      cartItemId:    'ci-${DateTime.now().millisecondsSinceEpoch}',
      productId:     product.id,
      slug:          product.slug,
      nameAr:        product.nameAr,
      nameEn:        product.nameEn,
      imageUrl:      product.mainImageUrl,
      unitPrice:     product.price,
      quantity:      _quantity,
      selectedColor: selected.colorId != null
          ? product.colorOptions
              .firstWhere((c) => c.id == selected.colorId,
                orElse: () => product.colorOptions.first)
              .valueAr
          : null,
      maxStock: product.stock,
    ));
    setState(() => _addedToCart = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _addedToCart = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic     = ref.watch(isArabicProvider);
    final productAsync = ref.watch(productDetailProvider(widget.slug));
    final favorites    = ref.watch(favoritesProvider);
    final isFav        = productAsync.value != null &&
        favorites.contains(productAsync.value!.id);

    return Scaffold(
      backgroundColor: context.screenBackground,
      body: productAsync.when(
        loading: () => const _DetailSkeleton(),
        error:   (e, _) => Center(
          child: Text(e.toString(),
              style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error)),
        ),
        data: (product) => Stack(
          children: [
            // ── Content ──────────────────────────────────────
            CustomScrollView(
              slivers: [
                // ── Sliver AppBar (Gallery) ─────────────────
                _GallerySliverAppBar(
                  product:      product,
                  galleryCtrl:  _galleryCtrl,
                  galleryIndex: _galleryIndex,
                  isFav:        isFav,
                  onGalleryChange: (i) =>
                      setState(() => _galleryIndex = i),
                  onFav: () {
                    HapticFeedback.lightImpact();
                    ref.read(favoritesProvider.notifier).update((s) {
                      final n = {...s};
                      s.contains(product.id)
                          ? n.remove(product.id)
                          : n.add(product.id);
                      return n;
                    });
                  },
                  onShare: () => HapticFeedback.lightImpact(),
                ),

                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.pagePadding, 16,
                          AppSpacing.pagePadding, 0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Badges row ──────────────────
                            if (product.isFeatured || product.freeShipping)
                              _BadgesRow(
                                product:  product,
                                isArabic: isArabic,
                              ),
                            const SizedBox(height: 8),

                            // ── Product name ────────────────
                            Text(
                              isArabic ? product.nameAr : product.nameEn,
                              style: isArabic
                                  ? AppTextStyles.arabicHeadlineMedium
                                      .copyWith(fontSize: 18)
                                  : AppTextStyles.headlineSmall,
                            ),
                            const SizedBox(height: 8),

                            // ── Vendor + Rating row ─────────
                            Row(
                              children: [
                                if (product.vendorName != null) ...[
                                  GestureDetector(
                                    onTap: () => context.push(
                                      AppRoutes.vendorPath(
                                          product.vendorSlug ?? ''),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.storefront_rounded,
                                            size: 14,
                                            color: AppColors.skyBlue),
                                        const SizedBox(width: 4),
                                        Text(
                                          product.vendorName!,
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                            color: AppColors.skyBlue,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                AppColors.skyBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                                const Icon(Icons.star_rounded,
                                    size: 14,
                                    color: AppColors.starFilled),
                                const SizedBox(width: 3),
                                Text(
                                  product.rating.toStringAsFixed(1),
                                  style: AppTextStyles.rating,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${product.totalRatings.toLocaleString()})',
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                            const Divider(color: AppColors.borderSubtle),
                            const SizedBox(height: 14),

                            // ── Price Section ────────────────
                            _PriceSection(
                              product:  product,
                              isArabic: isArabic,
                              quantity: _quantity,
                            ),

                            const SizedBox(height: 20),

                            // ── Variants ─────────────────────
                            if (product.colorOptions.isNotEmpty)
                              _ColorSelector(
                                options:  product.colorOptions,
                                isArabic: isArabic,
                              ),

                            if (product.sizeOptions.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              _SizeSelector(
                                options:  product.sizeOptions,
                                isArabic: isArabic,
                              ),
                            ],

                            if (product.modelOptions.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              _ModelSelector(
                                options:  product.modelOptions,
                                isArabic: isArabic,
                              ),
                            ],

                            const SizedBox(height: 20),

                            // ── Quantity ─────────────────────
                            _QuantityRow(
                              quantity:  _quantity,
                              maxStock:  product.stock,
                              isArabic:  isArabic,
                              onChanged: (q) => setState(() => _quantity = q),
                            ),

                            const SizedBox(height: 20),

                            // ── Delivery info ────────────────
                            _DeliveryInfo(
                              product:  product,
                              isArabic: isArabic,
                            ),

                            const SizedBox(height: 20),
                            const Divider(color: AppColors.borderSubtle),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),

                      // ── Description ─────────────────────
                      _DescriptionSection(
                        descriptionAr: product.descriptionAr,
                        descriptionEn: product.descriptionEn,
                        isExpanded:    _descExpanded,
                        isArabic:      isArabic,
                        onToggle: () => setState(
                          () => _descExpanded = !_descExpanded),
                      ),

                      const SizedBox(height: 24),
                      const Divider(color: AppColors.borderSubtle),

                      // ── Rating Breakdown ─────────────────
                      if (product.ratingSummary != null)
                        Padding(
                          padding: const EdgeInsets.all(
                              AppSpacing.pagePadding),
                          child: _RatingBreakdown(
                            summary:  product.ratingSummary!,
                            isArabic: isArabic,
                          ),
                        ),

                      // ── Reviews ──────────────────────────
                      if (product.reviews.isNotEmpty)
                        _ReviewsSection(
                          reviews:  product.reviews,
                          isArabic: isArabic,
                        ),

                      const SizedBox(height: 24),
                      const Divider(color: AppColors.borderSubtle),

                      // ── Upsells ──────────────────────────
                      if (product.upsells.isNotEmpty)
                        _UpsellsSection(
                          upsells:  product.upsells,
                          isArabic: isArabic,
                        ),

                      // Bottom padding for sticky bar
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),

            // ── Sticky Bottom Bar ──────────────────────────
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _StickyBottomBar(
                product:     product,
                isArabic:    isArabic,
                addedToCart: _addedToCart,
                onAddToCart: () => _addToCart(product),
                onBuyNow:    () {
                  _addToCart(product);
                  context.push(AppRoutes.checkout);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// GALLERY SLIVER APP BAR
// ──────────────────────────────────────────────────────────────
class _GallerySliverAppBar extends StatelessWidget {
  final ProductDetailModel product;
  final PageController     galleryCtrl;
  final int                galleryIndex;
  final bool               isFav;
  final ValueChanged<int>  onGalleryChange;
  final VoidCallback       onFav;
  final VoidCallback       onShare;

  const _GallerySliverAppBar({
    required this.product,
    required this.galleryCtrl,
    required this.galleryIndex,
    required this.isFav,
    required this.onGalleryChange,
    required this.onFav,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight:    360,
      pinned:            true,
      backgroundColor:   AppColors.bgScaffold,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:        AppColors.bgCard.withOpacity(0.9),
            shape:        BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: AppColors.textPrimary),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: onShare,
          child: Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.bgCard.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share_rounded,
                size: 18, color: AppColors.textPrimary),
          ),
        ),
        GestureDetector(
          onTap: onFav,
          child: Container(
            margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.bgCard.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFav
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              size:  18,
              color: isFav ? AppColors.error : AppColors.textPrimary,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Gallery
            PageView.builder(
              controller:  galleryCtrl,
              onPageChanged: onGalleryChange,
              itemCount:   product.images.isNotEmpty ? product.images.length : 1,
              itemBuilder: (_, i) {
                final img = product.images.isNotEmpty
                    ? product.images[i].url
                    : null;
                return img != null
                    ? CachedNetworkImage(
                        imageUrl:    img,
                        fit:         BoxFit.cover,
                        placeholder: (_, __) => Container(
                            color: AppColors.bgCard2),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.bgCard2,
                          child: const Icon(Icons.image_outlined,
                              color: AppColors.textMuted, size: 48),
                        ),
                      )
                    : Container(color: AppColors.bgCard2,
                        child: const Icon(Icons.image_outlined,
                            color: AppColors.textMuted, size: 48));
              },
            ),

            // Dot indicator
            Positioned(
              bottom: 12, left: 0, right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  product.images.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width:  i == galleryIndex ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: i == galleryIndex
                          ? AppColors.metallicGold
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),

            // Thumbnail strip at bottom
            if (product.images.length > 1)
              Positioned(
                bottom: 36, left: 12, right: 12,
                child: SizedBox(
                  height: 52,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:  product.images.length,
                    itemBuilder: (_, i) => GestureDetector(
                      onTap: () => galleryCtrl.animateToPage(i,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width:  52, height: 52,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: AppBorderRadius.sm,
                          border: Border.all(
                            color: i == galleryIndex
                                ? AppColors.metallicGold
                                : Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: AppBorderRadius.sm,
                          child: CachedNetworkImage(
                            imageUrl: product.images[i].url,
                            fit:      BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// PRICE SECTION
// ──────────────────────────────────────────────────────────────
class _PriceSection extends StatelessWidget {
  final ProductDetailModel product;
  final bool               isArabic;
  final int                quantity;
  const _PriceSection({
    required this.product,
    required this.isArabic,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final discount = product.discountPercent;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.compareAtPrice != null) ...[
              Row(
                children: [
                  Text(
                    '${product.compareAtPrice!.toInt()} ${product.currency}',
                    style: AppTextStyles.priceOriginalMedium,
                  ),
                  const SizedBox(width: 8),
                  if (discount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color:        AppColors.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-${discount.toInt()}%',
                        style: AppTextStyles.badgeMedium,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
            ],
            Text(
              '${product.price.toInt()} ${product.currency}',
              style: AppTextStyles.priceXLarge,
            ),
          ],
        ),
        const Spacer(),
        // Total for quantity
        if (quantity > 1)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isArabic ? 'الإجمالي' : 'Total',
                style: AppTextStyles.caption,
              ),
              Text(
                '${(product.price * quantity).toInt()} ${product.currency}',
                style: AppTextStyles.priceLarge
                    .copyWith(color: AppColors.skyBlue),
              ),
            ],
          ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────
// COLOR SELECTOR
// ──────────────────────────────────────────────────────────────
class _ColorSelector extends ConsumerWidget {
  final List<VariantOption> options;
  final bool                isArabic;
  const _ColorSelector({required this.options, required this.isArabic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedVariantsProvider).colorId;
    final notifier = ref.read(selectedVariantsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'اللون: ${_selectedName(selected)}' : 'Color: ${_selectedName(selected)}',
          style: isArabic
              ? AppTextStyles.arabicTitleSmall
              : AppTextStyles.titleSmall,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: options.map((o) {
            final isSelected = selected == o.id;
            final color = o.colorHex != null
                ? Color(int.parse('FF${o.colorHex!.replaceFirst('#', '')}', radix: 16))
                : AppColors.bgCard2;

            return GestureDetector(
              onTap: o.isAvailable
                  ? () {
                      HapticFeedback.selectionClick();
                      notifier.update((s) => s.copyWith(colorId: o.id));
                    }
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color:  color,
                  shape:  BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.metallicGold
                        : Colors.transparent,
                    width: 2.5,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color:      AppColors.metallicGold.withOpacity(0.4),
                      blurRadius: 8,
                    ),
                  ] : [],
                ),
                child: !o.isAvailable
                    ? CustomPaint(painter: _StrikePainter())
                    : isSelected
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 18)
                        : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _selectedName(String? id) {
    if (id == null) return isArabic ? 'اختر' : 'Select';
    return options
        .firstWhere((o) => o.id == id,
          orElse: () => options.first)
        .valueAr;
  }
}

class _StrikePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color  = Colors.white.withOpacity(0.8)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(size.width * 0.2, size.height * 0.8),
        Offset(size.width * 0.8, size.height * 0.2), paint);
  }
  @override
  bool shouldRepaint(_) => false;
}

// ──────────────────────────────────────────────────────────────
// SIZE SELECTOR
// ──────────────────────────────────────────────────────────────
class _SizeSelector extends ConsumerWidget {
  final List<VariantOption> options;
  final bool                isArabic;
  const _SizeSelector({required this.options, required this.isArabic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedVariantsProvider).sizeId;
    final notifier = ref.read(selectedVariantsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'المقاس' : 'Size',
          style: isArabic
              ? AppTextStyles.arabicTitleSmall
              : AppTextStyles.titleSmall,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: options.map((o) {
            final isSelected = selected == o.id;
            return GestureDetector(
              onTap: o.isAvailable
                  ? () => notifier.update((s) => s.copyWith(sizeId: o.id))
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.royalBlue.withOpacity(0.15)
                      : AppColors.bgCard2,
                  borderRadius: AppBorderRadius.sm,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.borderActive
                        : AppColors.borderSubtle,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  isArabic ? o.valueAr : o.valueEn,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: !o.isAvailable
                        ? AppColors.textDisabled
                        : isSelected
                            ? AppColors.royalBlue
                            : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────
// MODEL SELECTOR
// ──────────────────────────────────────────────────────────────
class _ModelSelector extends ConsumerWidget {
  final List<VariantOption> options;
  final bool                isArabic;
  const _ModelSelector({required this.options, required this.isArabic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedVariantsProvider).modelId;
    final notifier = ref.read(selectedVariantsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'الإصدار' : 'Model',
          style: isArabic
              ? AppTextStyles.arabicTitleSmall
              : AppTextStyles.titleSmall,
        ),
        const SizedBox(height: 10),
        ...options.map((o) {
          final isSelected = selected == o.id;
          return GestureDetector(
            onTap: () => notifier.update((s) => s.copyWith(modelId: o.id)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:        isSelected
                    ? AppColors.royalBlue.withOpacity(0.1)
                    : AppColors.bgCard,
                borderRadius: AppBorderRadius.md,
                border: Border.all(
                  color: isSelected
                      ? AppColors.borderActive
                      : AppColors.borderSubtle,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    isArabic ? o.valueAr : o.valueEn,
                    style: (isArabic
                            ? AppTextStyles.arabicBodyMedium
                            : AppTextStyles.bodyMedium)
                        .copyWith(
                      color: isSelected
                          ? AppColors.royalBlue
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (o.priceModifier != null && o.priceModifier! > 0) ...[
                    const SizedBox(width: 8),
                    Text(
                      '+${o.priceModifier!.toInt()} ر.س',
                      style: AppTextStyles.priceSmall,
                    ),
                  ],
                  const Spacer(),
                  if (isSelected)
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.royalBlue, size: 18),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────
// QUANTITY ROW
// ──────────────────────────────────────────────────────────────
class _QuantityRow extends StatelessWidget {
  final int      quantity;
  final int      maxStock;
  final bool     isArabic;
  final ValueChanged<int> onChanged;

  const _QuantityRow({
    required this.quantity,
    required this.maxStock,
    required this.isArabic,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          isArabic ? 'الكمية:' : 'Quantity:',
          style: isArabic
              ? AppTextStyles.arabicBodyMedium
              : AppTextStyles.bodyMedium,
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color:        AppColors.bgCard,
            borderRadius: AppBorderRadius.sm,
            border:       Border.all(color: AppColors.borderDefault),
          ),
          child: Row(
            children: [
              _QtyButton(
                icon:     Icons.remove_rounded,
                onTap:    quantity > 1 ? () => onChanged(quantity - 1) : null,
                enabled:  quantity > 1,
              ),
              Container(
                width:  44,
                height: 36,
                alignment: Alignment.center,
                child: Text(
                  '$quantity',
                  style: AppTextStyles.titleSmall,
                ),
              ),
              _QtyButton(
                icon:    Icons.add_rounded,
                onTap:   quantity < maxStock ? () => onChanged(quantity + 1) : null,
                enabled: quantity < maxStock,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          isArabic ? '$maxStock قطعة متوفرة' : '$maxStock in stock',
          style: AppTextStyles.caption.copyWith(
            color: maxStock <= 5 ? AppColors.warning : AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData  icon;
  final VoidCallback? onTap;
  final bool      enabled;
  const _QtyButton({required this.icon, this.onTap, required this.enabled});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width:  36, height: 36,
      child: Icon(icon,
          size: 18,
          color: enabled ? AppColors.textPrimary : AppColors.textDisabled),
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// BADGES ROW
// ──────────────────────────────────────────────────────────────
class _BadgesRow extends StatelessWidget {
  final ProductDetailModel product;
  final bool               isArabic;
  const _BadgesRow({required this.product, required this.isArabic});

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8, runSpacing: 6,
    children: [
      if (product.isFeatured)
        _Badge('⭐ ${isArabic ? 'مميز' : 'Featured'}',
            AppColors.metallicGold),
      if (product.freeShipping)
        _Badge('🚚 ${isArabic ? 'شحن مجاني' : 'Free Shipping'}',
            AppColors.success),
      if (product.stock <= 5 && product.stock > 0)
        _Badge('⚠️ ${isArabic ? 'كمية محدودة' : 'Low Stock'}',
            AppColors.warning),
    ],
  );
}

class _Badge extends StatelessWidget {
  final String label;
  final Color  color;
  const _Badge(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color:        color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(6),
      border:       Border.all(color: color.withOpacity(0.3)),
    ),
    child: Text(label,
        style: AppTextStyles.labelSmall.copyWith(color: color)),
  );
}

// ──────────────────────────────────────────────────────────────
// DELIVERY INFO
// ──────────────────────────────────────────────────────────────
class _DeliveryInfo extends StatelessWidget {
  final ProductDetailModel product;
  final bool               isArabic;
  const _DeliveryInfo({required this.product, required this.isArabic});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color:        AppColors.bgCard,
      borderRadius: AppBorderRadius.md,
      border:       Border.all(color: AppColors.borderSubtle),
    ),
    child: Column(
      children: [
        _DeliveryRow(
          icon:  Icons.local_shipping_outlined,
          text:  product.freeShipping
              ? (isArabic ? 'شحن مجاني' : 'Free Shipping')
              : (isArabic ? 'شحن: 25 ر.س' : 'Shipping: 25 SAR'),
          color: product.freeShipping ? AppColors.success : AppColors.textSecondary,
        ),
        if (product.deliveryDays != null) ...[
          const SizedBox(height: 8),
          _DeliveryRow(
            icon: Icons.schedule_rounded,
            text: isArabic
                ? 'التوصيل خلال ${product.deliveryDays} أيام عمل'
                : 'Delivery in ${product.deliveryDays} business days',
          ),
        ],
        const SizedBox(height: 8),
        _DeliveryRow(
          icon: Icons.verified_user_outlined,
          text: isArabic ? 'ضمان الجودة KAYAN' : 'KAYAN Quality Guarantee',
          color: AppColors.royalBlue,
        ),
      ],
    ),
  );
}

class _DeliveryRow extends StatelessWidget {
  final IconData icon;
  final String   text;
  final Color    color;
  const _DeliveryRow({
    required this.icon,
    required this.text,
    this.color = AppColors.textSecondary,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: 8),
      Expanded(
        child: Text(text,
            style: AppTextStyles.bodySmall.copyWith(color: color)),
      ),
    ],
  );
}

// ──────────────────────────────────────────────────────────────
// DESCRIPTION SECTION
// ──────────────────────────────────────────────────────────────
class _DescriptionSection extends StatelessWidget {
  final String?      descriptionAr;
  final String?      descriptionEn;
  final bool         isExpanded;
  final bool         isArabic;
  final VoidCallback onToggle;

  const _DescriptionSection({
    this.descriptionAr,
    this.descriptionEn,
    required this.isExpanded,
    required this.isArabic,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final text = isArabic
        ? (descriptionAr ?? descriptionEn)
        : (descriptionEn ?? descriptionAr);
    if (text == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'وصف المنتج' : 'Product Description',
            style: isArabic
                ? AppTextStyles.arabicTitleMedium
                : AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 10),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve:    Curves.easeOut,
            child: Text(
              text,
              maxLines:    isExpanded ? null : 3,
              overflow:    isExpanded ? null : TextOverflow.fade,
              style: (isArabic
                      ? AppTextStyles.arabicBodyMedium
                      : AppTextStyles.bodyMedium)
                  .copyWith(
                color:  AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onToggle,
            child: Text(
              isExpanded
                  ? (isArabic ? 'عرض أقل' : 'Show less')
                  : (isArabic ? 'عرض المزيد' : 'Show more'),
              style: AppTextStyles.seeAll,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// RATING BREAKDOWN
// ──────────────────────────────────────────────────────────────
class _RatingBreakdown extends StatelessWidget {
  final RatingSummary summary;
  final bool          isArabic;
  const _RatingBreakdown({required this.summary, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'التقييمات' : 'Ratings & Reviews',
          style: isArabic
              ? AppTextStyles.arabicTitleMedium
              : AppTextStyles.titleMedium,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Big number
            Column(
              children: [
                Text(
                  summary.avgRating.toStringAsFixed(1),
                  style: AppTextStyles.priceHero
                      .copyWith(color: AppColors.textPrimary),
                ),
                Row(
                  children: List.generate(5, (i) {
                    final fill = math.min(
                        1.0,
                        math.max(0.0, summary.avgRating - i),
                    );
                    return Icon(
                      fill >= 0.5
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      size:  14,
                      color: AppColors.starFilled,
                    );
                  }),
                ),
                const SizedBox(height: 2),
                Text(
                  '${summary.totalReviews.toLocaleString()} ${isArabic ? 'تقييم' : 'reviews'}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            const SizedBox(width: 20),
            // Bars
            Expanded(
              child: Column(
                children: List.generate(5, (i) {
                  final star = 5 - i;
                  final pct  = summary.percentFor(star);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Text('$star', style: AppTextStyles.caption),
                        const SizedBox(width: 4),
                        const Icon(Icons.star_rounded,
                            size: 10, color: AppColors.starFilled),
                        const SizedBox(width: 6),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value:            pct,
                              minHeight:        6,
                              backgroundColor:  AppColors.bgCard2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                pct > 0.5
                                    ? AppColors.metallicGold
                                    : AppColors.royalBlue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        SizedBox(
                          width: 24,
                          child: Text(
                            '${(pct * 100).toInt()}',
                            style: AppTextStyles.caption,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────
// REVIEWS SECTION
// ──────────────────────────────────────────────────────────────
class _ReviewsSection extends StatelessWidget {
  final List<ReviewModel> reviews;
  final bool              isArabic;
  const _ReviewsSection({required this.reviews, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Column(
        children: reviews.take(3).map((r) => _ReviewTile(
          review:   r,
          isArabic: isArabic,
        )).toList(),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ReviewModel review;
  final bool        isArabic;
  const _ReviewTile({required this.review, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:        AppColors.bgCard,
        borderRadius: AppBorderRadius.md,
        border:       Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 36, height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.bgCard2,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (review.userFirstName ?? '?')[0].toUpperCase(),
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.royalBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.userFirstName ?? 'مجهول',
                          style: AppTextStyles.titleSmall,
                        ),
                        if (review.isVerifiedPurchase) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified_rounded,
                              size: 14, color: AppColors.success),
                        ],
                      ],
                    ),
                    Row(
                      children: List.generate(5, (i) => Icon(
                        i < review.rating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size:  12,
                        color: AppColors.starFilled,
                      )),
                    ),
                  ],
                ),
              ),
              Text(
                _timeAgo(review.createdAt, isArabic),
                style: AppTextStyles.caption,
              ),
            ],
          ),
          if (review.comment != null) ...[
            const SizedBox(height: 8),
            Text(
              review.comment!,
              style: (isArabic
                      ? AppTextStyles.arabicBodySmall
                      : AppTextStyles.bodySmall)
                  .copyWith(color: AppColors.textSecondary, height: 1.5),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.thumb_up_outlined,
                  size: 12, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text('${review.helpfulCount}',
                  style: AppTextStyles.caption),
              const SizedBox(width: 4),
              Text(
                isArabic ? 'مفيد' : 'helpful',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dt, bool isArabic) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 30)  return isArabic ? '${diff.inDays ~/ 30} شهر' : '${diff.inDays ~/ 30}mo';
    if (diff.inDays > 0)   return isArabic ? '${diff.inDays} يوم'    : '${diff.inDays}d';
    if (diff.inHours > 0)  return isArabic ? '${diff.inHours} ساعة'  : '${diff.inHours}h';
    return isArabic ? 'الآن' : 'now';
  }
}

// ──────────────────────────────────────────────────────────────
// UPSELLS SECTION
// ──────────────────────────────────────────────────────────────
class _UpsellsSection extends StatelessWidget {
  final List<ProductCardSimple> upsells;
  final bool                    isArabic;
  const _UpsellsSection({required this.upsells, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
          child: Row(
            children: [
              Container(width: 3, height: 16,
                decoration: BoxDecoration(
                  gradient: AppGradients.goldButton,
                  borderRadius: BorderRadius.circular(2),
                )),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'قد يعجبك أيضاً' : 'You May Also Like',
                style: isArabic
                    ? AppTextStyles.arabicTitleMedium
                    : AppTextStyles.titleMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding:         const EdgeInsets.symmetric(
                horizontal: AppSpacing.pagePadding),
            itemCount:   upsells.length,
            itemBuilder: (_, i) {
              final u = upsells[i];
              return GestureDetector(
                onTap: () => context.push(AppRoutes.productPath(u.slug)),
                child: Container(
                  width:  110,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color:        AppColors.bgCard,
                    borderRadius: AppBorderRadius.md,
                    border:       Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                              AppBorderRadius.md.topLeft.x)),
                        child: SizedBox(
                          height: 72, width: double.infinity,
                          child: u.imageUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: u.imageUrl!,
                                  fit:      BoxFit.cover,
                                )
                              : Container(color: AppColors.bgCard2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u.nameAr,
                                style: AppTextStyles.arabicCaption
                                    .copyWith(fontSize: 10),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            Text('${u.price.toInt()} ر.س',
                                style: AppTextStyles.priceSmall
                                    .copyWith(fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────
// STICKY BOTTOM BAR
// ──────────────────────────────────────────────────────────────
class _StickyBottomBar extends StatelessWidget {
  final ProductDetailModel product;
  final bool               isArabic;
  final bool               addedToCart;
  final VoidCallback       onAddToCart;
  final VoidCallback       onBuyNow;

  const _StickyBottomBar({
    required this.product,
    required this.isArabic,
    required this.addedToCart,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    final isOOS = product.isOutOfStock;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding, 12,
        AppSpacing.pagePadding, 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: const Border(
          top: BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset:     const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Add to Cart
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: isOOS ? null : onAddToCart,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 50,
                decoration: BoxDecoration(
                  gradient: addedToCart
                      ? const LinearGradient(
                          colors: [AppColors.success, AppColors.successDark])
                      : isOOS
                          ? const LinearGradient(
                              colors: [AppColors.bgCard2, AppColors.bgCard2])
                          : AppGradients.primaryButton,
                  borderRadius: AppBorderRadius.button,
                  boxShadow: (!isOOS && !addedToCart) ? [
                    BoxShadow(
                      color:      AppColors.royalBlue.withOpacity(0.35),
                      blurRadius: 12,
                      offset:     const Offset(0, 4),
                    ),
                  ] : [],
                ),
                child: Center(
                  child: addedToCart
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              isArabic ? 'تمت الإضافة' : 'Added!',
                              style: isArabic
                                  ? AppTextStyles.arabicButton
                                      .copyWith(fontSize: 13)
                                  : AppTextStyles.buttonSmall,
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_cart_outlined,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              isOOS
                                  ? (isArabic ? 'نفد المخزون' : 'Out of Stock')
                                  : (isArabic ? 'أضف للسلة' : 'Add to Cart'),
                              style: isArabic
                                  ? AppTextStyles.arabicButton
                                      .copyWith(fontSize: 13)
                                  : AppTextStyles.buttonSmall,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Buy Now (Gold)
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: isOOS ? null : onBuyNow,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: isOOS
                      ? const LinearGradient(
                          colors: [AppColors.bgCard2, AppColors.bgCard2])
                      : AppGradients.goldButton,
                  borderRadius: AppBorderRadius.button,
                  boxShadow: !isOOS ? [
                    BoxShadow(
                      color:      AppColors.metallicGold.withOpacity(0.35),
                      blurRadius: 12,
                      offset:     const Offset(0, 4),
                    ),
                  ] : [],
                ),
                child: Center(
                  child: Text(
                    isArabic ? 'اشترِ الآن' : 'Buy Now',
                    style: (isArabic
                            ? AppTextStyles.arabicButton
                            : AppTextStyles.buttonMedium)
                        .copyWith(
                      color: isOOS
                          ? AppColors.textDisabled
                          : AppColors.bgPrimary,
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
// DETAIL SKELETON
// ──────────────────────────────────────────────────────────────
class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShimmerBox(width: double.infinity, height: 360,
            borderRadius: BorderRadius.zero),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerBox(width: double.infinity, height: 20),
              const SizedBox(height: 8),
              const ShimmerBox(width: 200, height: 16),
              const SizedBox(height: 16),
              const ShimmerBox(width: 140, height: 32),
              const SizedBox(height: 16),
              const ShimmerBox(width: double.infinity, height: 80),
            ],
          ),
        ),
      ],
    );
  }
}

// Extension helper
extension IntExt on int {
  String toLocaleString() => toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
}
