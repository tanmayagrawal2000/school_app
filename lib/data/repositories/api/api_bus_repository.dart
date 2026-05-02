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

  /// GET `/bus/routes`
  ///
  /// Returns all active bus routes with current GPS positions and stop details.
  /// No request parameters — server returns only routes relevant to the authenticated user.
  ///
  /// Note: `currentLat`/`currentLng` are the live bus position.
  /// Stop coordinates use `lat`/`lng` (different keys from the route-level position).
  /// Valid status values: `onRoute` | `atStop` | `delayed` | `completed`
  ///
  /// Sample response:
  /// ```json
  /// [
  ///   {
  ///     "id": "r001",
  ///     "routeName": "Route 1 – Indira Nagar",
  ///     "busNumber": "UP-78-1234",
  ///     "driverName": "Ramesh Yadav",
  ///     "driverContact": "9988776655",
  ///     "conductorName": "Suresh Kumar",
  ///     "stops": [
  ///       {
  ///         "name": "Indira Nagar Gate",
  ///         "lat": 26.4812,
  ///         "lng": 80.2775,
  ///         "arrivalTime": "07:15 AM",
  ///         "isPassed": true
  ///       },
  ///       {
  ///         "name": "Kidwai Nagar Chowk",
  ///         "lat": 26.4750,
  ///         "lng": 80.3010,
  ///         "arrivalTime": "07:25 AM",
  ///         "isPassed": false
  ///       }
  ///     ],
  ///     "currentLat": 26.4780,
  ///     "currentLng": 80.2890,
  ///     "nextStopIndex": 1,
  ///     "status": "onRoute",
  ///     "estimatedMinutes": 8
  ///   }
  /// ]
  /// ```
  @override
  Future<List<BusRoute>> fetchRoutes() async {
    final list = await _client.getList(ApiEndpoints.busRoutes);
    return list.map(BusRoute.fromJson).toList();
  }
}
