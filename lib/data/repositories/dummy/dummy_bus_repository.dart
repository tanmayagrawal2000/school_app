import '../../dummy/dummy_data.dart';
import '../../models/bus_model.dart';
import '../bus_repository.dart';

/// In-memory implementation of [BusRepository] backed by [DummyData].
///
/// Replace with [ApiBusRepository] in [app.dart] when the backend is ready.
class DummyBusRepository implements BusRepository {
  @override
  Future<List<BusRoute>> fetchRoutes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DummyData.busRoutes;
  }
}
