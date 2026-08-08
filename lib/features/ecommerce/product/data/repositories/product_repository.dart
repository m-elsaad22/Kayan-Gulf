import '../../../../home/data/models/home_models.dart';
import '../../data/models/product_models.dart';
import '../../domain/product_filter.dart';

/// Contract for loading product catalog data.
abstract class ProductRepository {
  Future<List<ProductCardModel>> getProducts(ProductFilter filter);

  Future<ProductDetailModel> getProductDetail(String slug);
}
