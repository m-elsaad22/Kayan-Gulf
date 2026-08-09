import '../../../../core/data/mock_data_catalog.dart';
import '../../../../core/services/admin_data_service.dart';
import '../../browse/data/models/ad_models.dart';
import '../../domain/ad_filter.dart';
import 'classifieds_repository.dart';

/// Local mock implementation — swap for [RemoteClassifiedsRepository] when API is ready.
class MockClassifiedsRepository implements ClassifiedsRepository {
  const MockClassifiedsRepository();

  @override
  Future<List<AdCategory>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockDataCatalog.adCategories;
  }

  @override
  Future<List<AdModel>> getAds(AdFilter filter) async {
    await Future.delayed(const Duration(milliseconds: 400));
    var ads = AdminDataService.instance.getClassifiedAds();

    if (filter.categorySlug != null && filter.categorySlug!.isNotEmpty) {
      ads = ads.where((a) => a.categorySlug == filter.categorySlug).toList();
    }
    if (filter.search != null && filter.search!.isNotEmpty) {
      final q = filter.search!.toLowerCase();
      ads = ads
          .where(
            (a) =>
                a.title.toLowerCase().contains(q) ||
                a.city.toLowerCase().contains(q),
          )
          .toList();
    }
    if (filter.featuredOnly) {
      ads = ads.where((a) => a.isFeatured || a.isBoosted).toList();
    }

    switch (filter.sort) {
      case AdSortOption.priceAsc:
        ads.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
      case AdSortOption.priceDesc:
        ads.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
      case AdSortOption.newest:
        ads.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    final start = (filter.page - 1) * 20;
    final end = (start + 20).clamp(0, ads.length);
    return start >= ads.length ? [] : ads.sublist(start, end);
  }

  @override
  Future<AdModel> getAdDetail(String slug) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final ads = AdminDataService.instance.getClassifiedAds();
    return ads.firstWhere(
      (a) => a.slug == slug,
      orElse: () => MockDataCatalog.adBySlug(slug) ?? MockDataCatalog.ads.first,
    );
  }

  @override
  Future<List<MyAdModel>> getMyAds() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MockDataCatalog.myAds;
  }

  @override
  Future<List<AdModel>> getFeaturedAds() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final featured = AdminDataService.instance.getClassifiedAds()
        .where((a) => a.isFeatured || a.isBoosted)
        .toList();
    return featured.isEmpty ? MockDataCatalog.featuredAds() : featured;
  }

  @override
  Future<AdModel> createAd({
    required String title,
    required String city,
    required String categorySlug,
    String? description,
    double? price,
    bool isFree = false,
    bool isNegotiable = false,
    String? district,
    String condition = 'good',
    List<String> imageUrls = const [],
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return AdModel(
      id: 'ad-${DateTime.now().millisecondsSinceEpoch}',
      slug: 'ad-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      price: isFree ? null : price,
      isFree: isFree,
      isNegotiable: isNegotiable,
      city: city,
      district: district ?? '',
      categoryId: categorySlug,
      categorySlug: categorySlug,
      condition: AdCondition.values.firstWhere(
        (c) => c.name == condition,
        orElse: () => AdCondition.good,
      ),
      imageUrls: imageUrls,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<MyAdModel> updateAdStatus(String id, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final mine = MockDataCatalog.myAds;
    final match = mine.firstWhere(
      (m) => m.ad.id == id,
      orElse: () => mine.first,
    );
    return MyAdModel(
      ad: match.ad,
      status: status,
      daysLeft: match.daysLeft,
      canBoost: status == 'ACTIVE',
    );
  }
}
