/// Ad list filter and sort options.
enum AdSortOption {
  newest,
  priceAsc,
  priceDesc,
}

class AdFilter {
  final String? categorySlug;
  final String? search;
  final AdSortOption sort;
  final bool featuredOnly;
  final int page;

  const AdFilter({
    this.categorySlug,
    this.search,
    this.sort = AdSortOption.newest,
    this.featuredOnly = false,
    this.page = 1,
  });

  AdFilter copyWith({
    String? categorySlug,
    String? search,
    AdSortOption? sort,
    bool? featuredOnly,
    int? page,
  }) =>
      AdFilter(
        categorySlug: categorySlug ?? this.categorySlug,
        search: search ?? this.search,
        sort: sort ?? this.sort,
        featuredOnly: featuredOnly ?? this.featuredOnly,
        page: page ?? this.page,
      );

  Map<String, dynamic> toQueryParams() => {
        if (categorySlug != null && categorySlug!.isNotEmpty)
          'categorySlug': categorySlug,
        if (search != null && search!.isNotEmpty) 'search': search,
        'sort': sort.name,
        if (featuredOnly) 'featuredOnly': true,
        'page': page,
      };
}
