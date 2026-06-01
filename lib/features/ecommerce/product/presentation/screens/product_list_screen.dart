// ============================================================
// KAYAN — Product List Screen
// lib/features/ecommerce/product/presentation/screens/product_list_screen.dart
//
// Features:
//   • Grid (2-col) / List toggle with animated transition
//   • Sort bottom sheet (5 options)
//   • Filter bottom sheet (price range, rating, in-stock, sale)
//   • Active filter chips with count badge
//   • Infinite scroll pagination
//   • Pull-to-refresh
//   • Empty state
//   • Category title in AppBar when browsing by category
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../../../shared/widgets/loaders/shimmer_loader.dart';
import '../providers/product_providers.dart';
import '../../data/models/product_models.dart';
import '../../../../../features/home/data/models/home_models.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  final String? categorySlug;
  final String? initialQuery;

  const ProductListScreen({
    super.key,
    this.categorySlug,
    this.initialQuery,
  });

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final ScrollController _scroll = ScrollController();
  bool _isGrid = true;

  @override
  void initState() {
    super.initState();
    // Set initial category filter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.categorySlug != null) {
        ref.read(productFilterProvider.notifier)
            .setCategory(widget.categorySlug);
      }
      if (widget.initialQuery != null) {
        ref.read(productFilterProvider.notifier)
            .setSearch(widget.initialQuery);
      }
    });

    // Pagination on scroll
    _scroll.addListener(() {
      if (_scroll.position.pixels >=
          _scroll.position.maxScrollExtent - 200) {
        ref.read(productFilterProvider.notifier).nextPage();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => const _SortBottomSheet(),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic  = ref.watch(isArabicProvider);
    final filter    = ref.watch(productFilterProvider);
    final products  = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,

      // ── App Bar ───────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface,
        centerTitle:     true,
        title: Text(
          widget.categorySlug != null
              ? _categoryName(widget.categorySlug!, isArabic)
              : (isArabic ? 'المنتجات' : 'Products'),
          style: isArabic
              ? AppTextStyles.arabicTitleMedium
              : AppTextStyles.titleMedium,
        ),
        leading: IconButton(
          icon: Icon(
            isArabic
                ? Icons.arrow_forward_ios_rounded
                : Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Search
          IconButton(
            icon: const Icon(Icons.search_rounded, size: 22),
            onPressed: () => context.push(AppRoutes.search),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.borderSubtle),
        ),
      ),

      body: Column(
        children: [
          // ── Filter/Sort bar ───────────────────────────────
          _FilterSortBar(
            isArabic:         isArabic,
            isGrid:           _isGrid,
            activeFilterCount: filter.activeFilterCount,
            sort:             filter.sort,
            onToggleView:     () => setState(() => _isGrid = !_isGrid),
            onSort:           _showSortSheet,
            onFilter:         _showFilterSheet,
          ),

          // ── Active filter chips ───────────────────────────
          if (filter.hasActiveFilters)
            _ActiveFilterChips(filter: filter, isArabic: isArabic),

          // ── Products grid/list ────────────────────────────
          Expanded(
            child: products.when(
              loading: () => _isGrid
                  ? _GridLoadingSkeleton()
                  : _ListLoadingSkeleton(),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 48, color: AppColors.textMuted),
                    const SizedBox(height: 12),
                    Text(isArabic ? 'فشل التحميل' : 'Load failed',
                        style: isArabic
                            ? AppTextStyles.arabicBodyMedium
                            : AppTextStyles.bodyMedium),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(productListProvider),
                      child: Text(isArabic ? 'إعادة' : 'Retry'),
                    ),
                  ],
                ),
              ),
              data: (list) => list.isEmpty
                  ? _EmptyState(isArabic: isArabic)
                  : RefreshIndicator(
                      color:       AppColors.royalBlue,
                      strokeWidth: 2,
                      onRefresh: () async =>
                          ref.invalidate(productListProvider),
                      child: _isGrid
                          ? _ProductGrid(
                              products: list,
                              scroll:   _scroll,
                              isArabic: isArabic,
                            )
                          : _ProductList(
                              products: list,
                              scroll:   _scroll,
                              isArabic: isArabic,
                            ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _categoryName(String slug, bool isArabic) {
    final names = {
      'electronics': isArabic ? 'إلكترونيات' : 'Electronics',
      'fashion':     isArabic ? 'أزياء'       : 'Fashion',
      'home':        isArabic ? 'المنزل'      : 'Home',
      'beauty':      isArabic ? 'جمال'        : 'Beauty',
      'sports':      isArabic ? 'رياضة'       : 'Sports',
    };
    return names[slug] ?? slug;
  }
}

// ──────────────────────────────────────────────────────────────
// FILTER / SORT BAR
// ──────────────────────────────────────────────────────────────
class _FilterSortBar extends StatelessWidget {
  final bool     isArabic;
  final bool     isGrid;
  final int      activeFilterCount;
  final SortOption sort;
  final VoidCallback onToggleView;
  final VoidCallback onSort;
  final VoidCallback onFilter;

  const _FilterSortBar({
    required this.isArabic,
    required this.isGrid,
    required this.activeFilterCount,
    required this.sort,
    required this.onToggleView,
    required this.onSort,
    required this.onFilter,
  });

  String get _sortLabel {
    return switch (sort) {
      SortOption.newest    => isArabic ? 'الأحدث'          : 'Newest',
      SortOption.priceAsc  => isArabic ? 'السعر: الأقل'    : 'Price: Low',
      SortOption.priceDesc => isArabic ? 'السعر: الأعلى'   : 'Price: High',
      SortOption.topRated  => isArabic ? 'الأعلى تقييماً' : 'Top Rated',
      SortOption.bestSeller=> isArabic ? 'الأكثر مبيعاً'  : 'Best Seller',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:  50,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(
          bottom: BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Sort button
          _BarButton(
            icon:    Icons.sort_rounded,
            label:   _sortLabel,
            onTap:   onSort,
            isArabic: isArabic,
          ),

          const SizedBox(width: AppSpacing.sm),
          Container(width: 1, height: 24, color: AppColors.borderSubtle),
          const SizedBox(width: AppSpacing.sm),

          // Filter button
          Stack(
            clipBehavior: Clip.none,
            children: [
              _BarButton(
                icon:    Icons.tune_rounded,
                label:   isArabic ? 'فلتر' : 'Filter',
                onTap:   onFilter,
                isArabic: isArabic,
                highlight: activeFilterCount > 0,
              ),
              if (activeFilterCount > 0)
                Positioned(
                  top: -2, right: -2,
                  child: Container(
                    width:  14, height: 14,
                    decoration: const BoxDecoration(
                      color: AppColors.royalBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$activeFilterCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const Spacer(),

          // Grid/List toggle
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onToggleView();
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isGrid
                    ? Icons.view_list_rounded
                    : Icons.grid_view_rounded,
                key:   ValueKey(isGrid),
                color: AppColors.textSecondary,
                size:  22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final IconData icon;
  final String   label;
  final VoidCallback onTap;
  final bool     isArabic;
  final bool     highlight;

  const _BarButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isArabic,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Row(
      children: [
        Icon(icon,
            size: 18,
            color: highlight ? AppColors.royalBlue : AppColors.textSecondary),
        const SizedBox(width: 5),
        Text(
          label,
          style: (isArabic
                  ? AppTextStyles.arabicBodySmall
                  : AppTextStyles.bodySmall)
              .copyWith(
            color: highlight ? AppColors.royalBlue : AppColors.textSecondary,
            fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// ACTIVE FILTER CHIPS
// ──────────────────────────────────────────────────────────────
class _ActiveFilterChips extends ConsumerWidget {
  final ProductFilter filter;
  final bool          isArabic;

  const _ActiveFilterChips({required this.filter, required this.isArabic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(productFilterProvider.notifier);

    return Container(
      height:  40,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      color:   AppColors.bgScaffold,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Reset all
          _FilterChip(
            label:    isArabic ? 'مسح الكل' : 'Clear All',
            color:    AppColors.error,
            onRemove: notifier.reset,
            isRemovable: false,
            icon: Icons.close_rounded,
          ),
          if (filter.minPrice != null || filter.maxPrice != null)
            _FilterChip(
              label: 'السعر: ${filter.minPrice?.toInt() ?? 0} - ${filter.maxPrice?.toInt() ?? '∞'} ر.س',
              onRemove: () => notifier.setPriceRange(null, null),
            ),
          if (filter.minRating != null)
            _FilterChip(
              label: '⭐ ${filter.minRating!.toStringAsFixed(1)}+',
              onRemove: () => notifier.setMinRating(null),
            ),
          if (filter.inStockOnly)
            _FilterChip(
              label: isArabic ? 'متوفر' : 'In Stock',
              onRemove: notifier.toggleInStock,
            ),
          if (filter.onSaleOnly)
            _FilterChip(
              label: isArabic ? 'تخفيض' : 'On Sale',
              onRemove: notifier.toggleOnSale,
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String       label;
  final VoidCallback onRemove;
  final bool         isRemovable;
  final Color        color;
  final IconData?    icon;

  const _FilterChip({
    required this.label,
    required this.onRemove,
    this.isRemovable = true,
    this.color       = AppColors.royalBlue,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRemove,
      child: Container(
        margin: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          color:        color.withOpacity(0.12),
          borderRadius: AppBorderRadius.pill,
          border:       Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
            ],
            Text(label,
                style: AppTextStyles.labelSmall.copyWith(color: color)),
            if (isRemovable) ...[
              const SizedBox(width: 4),
              Icon(Icons.close_rounded, size: 12, color: color),
            ],
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// PRODUCT GRID
// ──────────────────────────────────────────────────────────────
class _ProductGrid extends ConsumerWidget {
  final List<ProductCardModel> products;
  final ScrollController        scroll;
  final bool                    isArabic;

  const _ProductGrid({
    required this.products,
    required this.scroll,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return GridView.builder(
      controller:  scroll,
      padding:     const EdgeInsets.all(AppSpacing.pagePadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:   2,
        crossAxisSpacing: 12,
        mainAxisSpacing:  12,
        childAspectRatio: 0.65,
      ),
      itemCount:  products.length,
      itemBuilder: (_, i) {
        final p = products[i];
        return ProductCard(
          product:     p,
          isFavorited: favorites.contains(p.id),
          onTap:       () => context.push(AppRoutes.productPath(p.slug)),
          onFavorite: () {
            HapticFeedback.lightImpact();
            ref.read(favoritesProvider.notifier).update((s) {
              final next = {...s};
              s.contains(p.id) ? next.remove(p.id) : next.add(p.id);
              return next;
            });
          },
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────
// PRODUCT LIST (horizontal card)
// ──────────────────────────────────────────────────────────────
class _ProductList extends ConsumerWidget {
  final List<ProductCardModel> products;
  final ScrollController        scroll;
  final bool                    isArabic;

  const _ProductList({
    required this.products,
    required this.scroll,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      controller:  scroll,
      padding:     const EdgeInsets.all(AppSpacing.pagePadding),
      itemCount:   products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final p = products[i];
        return ProductCard(
          product:      p,
          isHorizontal: true,
          onTap:        () => context.push(AppRoutes.productPath(p.slug)),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────
// SORT BOTTOM SHEET
// ──────────────────────────────────────────────────────────────
class _SortBottomSheet extends ConsumerWidget {
  const _SortBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(isArabicProvider);
    final current  = ref.watch(productFilterProvider).sort;
    final notifier = ref.read(productFilterProvider.notifier);

    final options = [
      (SortOption.newest,    isArabic ? 'الأحدث'          : 'Newest First'),
      (SortOption.priceAsc,  isArabic ? 'السعر: من الأقل' : 'Price: Low to High'),
      (SortOption.priceDesc, isArabic ? 'السعر: من الأعلى': 'Price: High to Low'),
      (SortOption.topRated,  isArabic ? 'الأعلى تقييماً' : 'Top Rated'),
      (SortOption.bestSeller,isArabic ? 'الأكثر مبيعاً'  : 'Best Seller'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color:        AppColors.bgBottomSheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderDefault,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                isArabic ? 'ترتيب حسب' : 'Sort By',
                style: isArabic
                    ? AppTextStyles.arabicTitleMedium
                    : AppTextStyles.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...options.map((o) {
            final isSelected = current == o.$1;
            return ListTile(
              onTap: () {
                HapticFeedback.selectionClick();
                notifier.setSort(o.$1);
                Navigator.pop(context);
              },
              title: Text(o.$2,
                  style: (isArabic
                          ? AppTextStyles.arabicBodyMedium
                          : AppTextStyles.bodyMedium)
                      .copyWith(
                        color: isSelected
                            ? AppColors.royalBlue
                            : AppColors.textPrimary,
                      )),
              trailing: isSelected
                  ? const Icon(Icons.check_circle_rounded,
                      color: AppColors.royalBlue, size: 20)
                  : null,
              selected: isSelected,
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// FILTER BOTTOM SHEET
// ──────────────────────────────────────────────────────────────
class _FilterBottomSheet extends ConsumerStatefulWidget {
  const _FilterBottomSheet();
  @override
  ConsumerState<_FilterBottomSheet> createState() =>
      _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<_FilterBottomSheet> {
  late RangeValues _priceRange;
  double? _minRating;
  bool    _inStock = false;
  bool    _onSale  = false;

  @override
  void initState() {
    super.initState();
    final f = ref.read(productFilterProvider);
    _priceRange = RangeValues(f.minPrice ?? 0, f.maxPrice ?? 5000);
    _minRating  = f.minRating;
    _inStock    = f.inStockOnly;
    _onSale     = f.onSaleOnly;
  }

  void _apply() {
    final n = ref.read(productFilterProvider.notifier);
    n.setPriceRange(
      _priceRange.start > 0    ? _priceRange.start : null,
      _priceRange.end   < 5000 ? _priceRange.end   : null,
    );
    n.setMinRating(_minRating);
    if (_inStock != ref.read(productFilterProvider).inStockOnly) n.toggleInStock();
    if (_onSale  != ref.read(productFilterProvider).onSaleOnly)  n.toggleOnSale();
    Navigator.pop(context);
  }

  void _reset() {
    setState(() {
      _priceRange = const RangeValues(0, 5000);
      _minRating  = null;
      _inStock    = false;
      _onSale     = false;
    });
    ref.read(productFilterProvider.notifier).reset();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(isArabicProvider);

    return DraggableScrollableSheet(
      expand:           false,
      initialChildSize: 0.7,
      maxChildSize:     0.9,
      builder: (_, scroll) => Container(
        decoration: const BoxDecoration(
          color:        AppColors.bgBottomSheet,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.borderDefault,
                  borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(isArabic ? 'تصفية المنتجات' : 'Filter Products',
                      style: isArabic
                          ? AppTextStyles.arabicTitleMedium
                          : AppTextStyles.titleMedium),
                  const Spacer(),
                  TextButton(
                    onPressed: _reset,
                    child: Text(isArabic ? 'مسح' : 'Reset',
                        style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.error)),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.borderSubtle),

            Expanded(
              child: ListView(
                controller: scroll,
                padding: const EdgeInsets.all(20),
                children: [
                  // Price Range
                  Text(isArabic ? 'نطاق السعر' : 'Price Range',
                      style: isArabic
                          ? AppTextStyles.arabicTitleSmall
                          : AppTextStyles.titleSmall),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_priceRange.start.toInt()} ر.س',
                          style: AppTextStyles.priceMedium),
                      Text('${_priceRange.end.toInt()} ر.س',
                          style: AppTextStyles.priceMedium),
                    ],
                  ),
                  RangeSlider(
                    values:   _priceRange,
                    min:      0,
                    max:      5000,
                    divisions: 50,
                    onChanged: (v) => setState(() => _priceRange = v),
                  ),
                  const SizedBox(height: 20),

                  // Min Rating
                  Text(isArabic ? 'أدنى تقييم' : 'Minimum Rating',
                      style: isArabic
                          ? AppTextStyles.arabicTitleSmall
                          : AppTextStyles.titleSmall),
                  const SizedBox(height: 10),
                  Row(
                    children: [null, 3.0, 4.0, 4.5].map((r) {
                      final isSelected = _minRating == r;
                      return GestureDetector(
                        onTap: () => setState(() => _minRating = r),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color:        isSelected
                                ? AppColors.royalBlue.withOpacity(0.15)
                                : AppColors.bgCard2,
                            borderRadius: AppBorderRadius.pill,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.borderActive
                                  : AppColors.borderSubtle,
                            ),
                          ),
                          child: Text(
                            r == null
                                ? (isArabic ? 'الكل' : 'All')
                                : '⭐ $r+',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: isSelected
                                  ? AppColors.royalBlue
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Switches
                  _FilterSwitch(
                    label:    isArabic ? 'متوفر في المخزون فقط' : 'In Stock Only',
                    value:    _inStock,
                    onChanged: (v) => setState(() => _inStock = v),
                    isArabic: isArabic,
                  ),
                  _FilterSwitch(
                    label:    isArabic ? 'عروض وتخفيضات فقط' : 'On Sale Only',
                    value:    _onSale,
                    onChanged: (v) => setState(() => _onSale = v),
                    isArabic: isArabic,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Apply button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: GestureDetector(
                onTap: _apply,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    gradient:     AppGradients.primaryButton,
                    borderRadius: AppBorderRadius.button,
                  ),
                  child: Center(
                    child: Text(
                      isArabic ? 'تطبيق الفلتر' : 'Apply Filters',
                      style: isArabic
                          ? AppTextStyles.arabicButton
                          : AppTextStyles.buttonMedium,
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

class _FilterSwitch extends StatelessWidget {
  final String   label;
  final bool     value;
  final ValueChanged<bool> onChanged;
  final bool     isArabic;
  const _FilterSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.isArabic,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: isArabic
                ? AppTextStyles.arabicBodyMedium
                : AppTextStyles.bodyMedium),
        Switch(value: value, onChanged: onChanged),
      ],
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// LOADING SKELETONS
// ──────────────────────────────────────────────────────────────
class _GridLoadingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(16),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, crossAxisSpacing: 12,
      mainAxisSpacing: 12, childAspectRatio: 0.65,
    ),
    itemCount: 6,
    itemBuilder: (_, __) => const ProductCardShimmer(),
  );
}

class _ListLoadingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView.separated(
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(16),
    itemCount: 6,
    separatorBuilder: (_, __) => const SizedBox(height: 10),
    itemBuilder: (_, __) => const ShimmerBox(
      width: double.infinity, height: 110,
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// EMPTY STATE
// ──────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final bool isArabic;
  const _EmptyState({required this.isArabic});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.search_off_rounded,
            size: 72, color: AppColors.textMuted),
        const SizedBox(height: 16),
        Text(
          isArabic ? 'لا توجد منتجات' : 'No Products Found',
          style: isArabic
              ? AppTextStyles.arabicTitleMedium
              : AppTextStyles.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          isArabic
              ? 'جرب تغيير الفلاتر أو البحث بكلمة أخرى'
              : 'Try adjusting filters or a different search',
          style: (isArabic
                  ? AppTextStyles.arabicBodySmall
                  : AppTextStyles.bodySmall)
              .copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
