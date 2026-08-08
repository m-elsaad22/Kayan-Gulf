import '../../../../core/network/api_client.dart';
import '../../data/models/home_models.dart';
import 'home_repository.dart';

/// HTTP implementation — ready to connect when backend is live.
class RemoteHomeRepository implements HomeRepository {
  const RemoteHomeRepository(this._client);

  final ApiClient _client;

  @override
  Future<HomeData> getHomeData() async {
    final json = await _client.getJson('/home');
    return HomeData.fromJson(json);
  }
}
