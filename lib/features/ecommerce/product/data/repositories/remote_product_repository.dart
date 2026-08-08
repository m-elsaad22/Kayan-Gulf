import '../../../../../core/network/api_client.dart';
import '../../../../home/data/models/home_models.dart';
import '../../data/models/product_models.dart';
import '../../domain/product_filter.dart';
import 'product_repository.dart';

/// HTTP implementation — ready to connect when backend is live.
class RemoteProductRepository implements ProductRepository {
  const RemoteProductRepository(this._client);

  final ApiClient _client;

  @override
  Future<List<ProductCardModel>> getProducts(ProductFilter filter) async {
    final json = await _client.getJson(
      '/products',
      query: filter.toQueryParams(),
    );
    final items = json['items'] as List? ?? json['data'] as List? ?? [];
    return items
        .map((e) => ProductCardModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductDetailModel> getProductDetail(String slug) async {
    final json = await _client.getJson('/products/$slug');
    final data = json['product'] as Map<String, dynamic>? ?? json;
    return ProductDetailModel.fromJson(data);
  }
}
