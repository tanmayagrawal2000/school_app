import '../models/bus_model.dart';

/// Contract for bus-tracking data operations.
///
/// Swap implementations in [app.dart]:
/// - [DummyBusRepository] — in-memory data, no network required.
/// - [ApiBusRepository]   — live backend via [ApiClient].
abstract class BusRepository {
  /// Returns all active bus routes with current positions.
  Future<List<BusRoute>> fetchRoutes();
}
