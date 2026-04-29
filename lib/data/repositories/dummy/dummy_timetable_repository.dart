import '../../dummy/dummy_data.dart';
import '../../models/timetable_model.dart';
import '../timetable_repository.dart';

/// In-memory implementation of [TimetableRepository] backed by [DummyData].
///
/// Replace with [ApiTimetableRepository] in [app.dart] when the backend is ready.
class DummyTimetableRepository implements TimetableRepository {
  @override
  Future<Map<String, List<TimetablePeriod>>> fetchTimetable(
      String classGrade, String section) async {
    await Future.delayed(const Duration(milliseconds: 350));
    // Only Class 10-A timetable exists in dummy data.
    return DummyData.timetableClass10A;
  }

  @override
  int periodsCountForDay(
      Map<String, List<TimetablePeriod>> timetable, String dayName) {
    return (timetable[dayName] ?? []).where((p) => !p.isBreak).length;
  }
}
