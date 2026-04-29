import '../models/timetable_model.dart';

/// Contract for timetable data operations.
///
/// Swap implementations in [app.dart]:
/// - [DummyTimetableRepository] — in-memory data, no network required.
/// - [ApiTimetableRepository]   — live backend via [ApiClient].
abstract class TimetableRepository {
  /// Returns the weekly timetable for [classGrade]-[section].
  ///
  /// The returned map key is the day name (e.g. `'Monday'`).
  Future<Map<String, List<TimetablePeriod>>> fetchTimetable(
      String classGrade, String section);

  /// Counts non-break periods for [dayName] in [timetable].
  int periodsCountForDay(
      Map<String, List<TimetablePeriod>> timetable, String dayName);
}
