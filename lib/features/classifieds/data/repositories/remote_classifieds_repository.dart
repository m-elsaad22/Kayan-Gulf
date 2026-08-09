import '../../../../core/network/api_client.dart';
import '../../browse/data/models/ad_models.dart';
import '../../domain/ad_filter.dart';
import 'classifieds_repository.dart';

/// HTTP implementation — ready to connect when backend is live.
class RemoteClassifiedsRepository implements ClassifiedsRepository {
  const RemoteClassifiedsRepository(this._client);

  final ApiClient _client;

  @override
  Future<List<AdCategory>> getCategories() async {
    final json = await _client.getJson('/classifieds/categories');
    final items = json['items'] as List? ?? json['data'] as List? ?? [];
    return items
        .map((e) => AdCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<AdModel>> getAds(AdFilter filter) async {
    final json = await _client.getJson(
      '/classifieds/ads',
      query: filter.toQueryParams(),
    );
    final items = json['items'] as List? ?? json['data'] as List? ?? [];
    return items
        .map((e) => AdModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AdModel> getAdDetail(String slug) async {
    final json = await _client.getJson('/classifieds/ads/$slug');
    final data = json['ad'] as Map<String, dynamic>? ?? json;
    return AdModel.fromJson(data);
  }

  @override
  Future<List<MyAdModel>> getMyAds() async {
    final json = await _client.getJson('/classifieds/my-ads');
    final items = json['items'] as List? ?? json['data'] as List? ?? [];
    return items
        .map((e) => MyAdModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<AdModel>> getFeaturedAds() async {
    final json = await _client.getJson('/classifieds/ads/featured');
    final items = json['items'] as List? ?? json['data'] as List? ?? [];
    return items
        .map((e) => AdModel.fromJson(e as Map<String, dynamic>))
        .toList();
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
    final json = await _client.postJson(
      '/classifieds/ads',
      body: {
        'title': title,
        'city': city,
        'categorySlug': categorySlug,
        if (description != null) 'description': description,
        if (price != null) 'price': price,
        'isFree': isFree,
        'isNegotiable': isNegotiable,
        if (district != null) 'district': district,
        'condition': condition,
        'imageUrls': imageUrls,
      },
    );
    final data = json['ad'] as Map<String, dynamic>? ?? json;
    return AdModel.fromJson(data);
  }

  @override
  Future<MyAdModel> updateAdStatus(String id, String status) async {
    final json = await _client.patchJson(
      '/classifieds/ads/$id/status',
      body: {'status': status},
    );
    return MyAdModel.fromJson(json);
  }
}
