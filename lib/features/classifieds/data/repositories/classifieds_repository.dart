import '../../browse/data/models/ad_models.dart';
import '../../domain/ad_filter.dart';

/// Contract for loading classifieds data.
abstract class ClassifiedsRepository {
  Future<List<AdCategory>> getCategories();

  Future<List<AdModel>> getAds(AdFilter filter);

  Future<AdModel> getAdDetail(String slug);

  Future<List<MyAdModel>> getMyAds();

  Future<List<AdModel>> getFeaturedAds();
}
