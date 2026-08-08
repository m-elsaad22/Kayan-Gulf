/// Product list filter and sort options — shared by providers and repositories.
enum SortOption {
  newest,
  priceAsc,
  priceDesc,
  topRated,
  bestSeller,
}

class ProductFilter {
  final String? categorySlug;
  final String? search;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final SortOption sort;
  final bool inStockOnly;
  final bool onSaleOnly;
  final int page;

  const ProductFilter({
    this.categorySlug,
    this.search,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.sort = SortOption.newest,
    this.inStockOnly = false,
    this.onSaleOnly = false,
    this.page = 1,
  });

  ProductFilter copyWith({
    String? categorySlug,
    String? search,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    SortOption? sort,
    bool? inStockOnly,
    bool? onSaleOnly,
    int? page,
  }) =>
      ProductFilter(
        categorySlug: categorySlug ?? this.categorySlug,
        search: search ?? this.search,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        minRating: minRating ?? this.minRating,
        sort: sort ?? this.sort,
        inStockOnly: inStockOnly ?? this.inStockOnly,
        onSaleOnly: onSaleOnly ?? this.onSaleOnly,
        page: page ?? this.page,
      );

  bool get hasActiveFilters =>
      minPrice != null ||
      maxPrice != null ||
      minRating != null ||
      inStockOnly ||
      onSaleOnly ||
      sort != SortOption.newest;

  int get activeFilterCount {
    var count = 0;
    if (minPrice != null || maxPrice != null) count++;
    if (minRating != null) count++;
    if (inStockOnly) count++;
    if (onSaleOnly) count++;
    if (sort != SortOption.newest) count++;
    return count;
  }

  Map<String, dynamic> toQueryParams() => {
        if (categorySlug != null && categorySlug!.isNotEmpty)
          'categorySlug': categorySlug,
        if (search != null && search!.isNotEmpty) 'search': search,
        if (minPrice != null) 'minPrice': minPrice,
        if (maxPrice != null) 'maxPrice': maxPrice,
        if (minRating != null) 'minRating': minRating,
        'sort': sort.name,
        if (inStockOnly) 'inStockOnly': true,
        if (onSaleOnly) 'onSaleOnly': true,
        'page': page,
      };
}
