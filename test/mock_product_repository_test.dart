import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/features/ecommerce/product/data/repositories/mock_product_repository.dart';
import 'package:kayan/features/ecommerce/product/domain/product_filter.dart';

void main() {
  group('MockProductRepository', () {
    const repo = MockProductRepository();

    test('returns product list with default filter', () async {
      final products = await repo.getProducts(const ProductFilter());
      expect(products, isNotEmpty);
      expect(products.first.slug, isNotEmpty);
    });

    test('filters products by search query', () async {
      final all = await repo.getProducts(const ProductFilter());
      if (all.isEmpty) return;

      final firstName = all.first.nameAr;
      final filtered = await repo.getProducts(
        ProductFilter(search: firstName.substring(0, 2)),
      );
      expect(filtered, isNotEmpty);
    });

    test('sorts products by price ascending', () async {
      final products = await repo.getProducts(
        const ProductFilter(sort: SortOption.priceAsc),
      );
      if (products.length < 2) return;

      for (var i = 0; i < products.length - 1; i++) {
        expect(
          products[i].price <= products[i + 1].price,
          isTrue,
        );
      }
    });

    test('returns product detail for known slug', () async {
      final list = await repo.getProducts(const ProductFilter());
      if (list.isEmpty) return;

      final detail = await repo.getProductDetail(list.first.slug);
      expect(detail.slug, list.first.slug);
      expect(detail.nameAr, isNotEmpty);
      expect(detail.price, greaterThan(0));
    });

    test('returns fallback detail for unknown slug', () async {
      final detail = await repo.getProductDetail('unknown-slug-xyz');
      expect(detail.slug, 'unknown-slug-xyz');
      expect(detail.reviews, isNotEmpty);
    });
  });

  group('ProductFilter', () {
    test('toQueryParams includes active filters', () {
      const filter = ProductFilter(
        categorySlug: 'electronics',
        search: 'sony',
        minPrice: 100,
        maxPrice: 2000,
        minRating: 4,
        sort: SortOption.topRated,
        inStockOnly: true,
        onSaleOnly: true,
        page: 2,
      );

      final params = filter.toQueryParams();
      expect(params['categorySlug'], 'electronics');
      expect(params['search'], 'sony');
      expect(params['minPrice'], 100);
      expect(params['maxPrice'], 2000);
      expect(params['minRating'], 4);
      expect(params['sort'], 'topRated');
      expect(params['inStockOnly'], isTrue);
      expect(params['onSaleOnly'], isTrue);
      expect(params['page'], 2);
    });
  });
}
