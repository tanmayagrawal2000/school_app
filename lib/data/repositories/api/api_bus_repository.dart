import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../models/bus_model.dart';
import '../bus_repository.dart';

/// Live API implementation of [BusRepository].
///
/// To activate, update [app.dart]:
/// ```dart
/// RepositoryProvider<BusRepository>(
///   create: (_) => ApiBusRepository(ApiClient()),
/// ),
/// ```
class ApiBusRepository implements BusRepository {
  final ApiClient _client;

  ApiBusRepository(this._client);

  @override
  Future<List<BusRoute>> fetchRoutes() async {
    final list = await _client.getList(ApiEndpoints.busRoutes);
    return list.map(BusRoute.fromJson).toList();
  }
}
