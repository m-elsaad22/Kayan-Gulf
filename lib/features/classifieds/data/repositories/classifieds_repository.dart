import '../../browse/data/models/ad_models.dart';
import '../../domain/ad_filter.dart';

/// Contract for loading classifieds data.
abstract class ClassifiedsRepository {
  Future<List<AdCategory>> getCategories();

  Future<List<AdModel>> getAds(AdFilter filter);

  Future<AdModel> getAdDetail(String slug);

  Future<List<MyAdModel>> getMyAds();

  Future<List<AdModel>> getFeaturedAds();

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
  });

  Future<MyAdModel> updateAdStatus(String id, String status);
}
