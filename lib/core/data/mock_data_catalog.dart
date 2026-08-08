import '../../../features/classifieds/browse/data/models/ad_models.dart';
import '../../../features/services/browse/data/models/service_models.dart';
import 'mock/mock_products.dart';
import 'mock/mock_user.dart';

/// Single entry point for all local mock seed data used by repositories.
///
/// Repositories and [AdminDataService] should read fallback data through this
/// catalog instead of importing feature model files directly.
abstract final class MockDataCatalog {
  // ── Commerce ────────────────────────────────────────────────
  static List<MockProductCategory> get productCategories =>
      mockProductCategories;

  static List<MockProduct> get products => mockProducts;

  // ── Classifieds ─────────────────────────────────────────────
  static List<AdCategory> get adCategories => mockAdCategories;

  static List<AdModel> get ads => mockAds;

  static List<MyAdModel> get myAds => mockMyAds;

  static AdModel? adBySlug(String slug) {
    for (final ad in mockAds) {
      if (ad.slug == slug) return ad;
    }
    return null;
  }

  static List<AdModel> adsByCategory(String categorySlug) =>
      mockAds.where((a) => a.categorySlug == categorySlug).toList();

  static List<AdModel> featuredAds() =>
      mockAds.where((a) => a.isFeatured || a.isBoosted).toList();

  // ── Services ────────────────────────────────────────────────
  static List<ServiceCategory> get serviceCategories => mockServiceCategories;

  static List<BookingModel> get bookings => mockBookings;

  static ServiceDetailModel serviceDetail(String slug) => mockServiceDetail(slug);

  static List<ServiceDetailModel> serviceDetails({String? categorySlug}) {
    final all = mockServiceCategories
        .map((category) => mockServiceDetail(category.slug))
        .toList();
    if (categorySlug == null || categorySlug.isEmpty) return all;
    return all
        .where(
          (s) => s.categorySlug == categorySlug || s.slug == categorySlug,
        )
        .toList();
  }

  static List<BookingModel> bookingsByStatus(String? status) {
    if (status == null || status.isEmpty) return mockBookings;
    return mockBookings.where((b) => b.status == status).toList();
  }

  // ── User ────────────────────────────────────────────────────
  static MockUser get guestUser => mockGuestUser;

  static MockUser get signedInUser => mockSignedInUser;
}
