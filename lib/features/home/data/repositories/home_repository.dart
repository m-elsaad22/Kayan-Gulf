import '../../data/models/home_models.dart';

/// Contract for loading the home dashboard payload.
abstract class HomeRepository {
  Future<HomeData> getHomeData();
}
