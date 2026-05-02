import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../models/timetable_model.dart';
import '../timetable_repository.dart';

/// Live API implementation of [TimetableRepository].
///
/// To activate, update [app.dart]:
/// ```dart
/// RepositoryProvider<TimetableRepository>(
///   create: (_) => ApiTimetableRepository(ApiClient()),
/// ),
/// ```
class ApiTimetableRepository implements TimetableRepository {
  final ApiClient _client;

  ApiTimetableRepository(this._client);

  /// GET `/academic/timetable?classGrade={classGrade}&section={section}`
  ///
  /// Sample input: `classGrade = "10"`, `section = "A"`
  ///
  /// Returns a map keyed by full day name. All seven days are expected even if empty.
  /// Periods with `subject = "Break"` or `subject = "Lunch"` are treated as non-teaching
  /// periods and excluded from [periodsCountForDay].
  ///
  /// Sample response:
  /// ```json
  /// {
  ///   "Monday": [
  ///     { "time": "08:00 – 08:45", "subject": "Mathematics", "teacher": "Mrs. Sunita Verma",  "room": "101" },
  ///     { "time": "08:45 – 09:30", "subject": "Science",     "teacher": "Mr. Anil Kumar",     "room": "Lab 1" },
  ///     { "time": "09:30 – 09:45", "subject": "Break",       "teacher": "",                   "room": "" },
  ///     { "time": "09:45 – 10:30", "subject": "English",     "teacher": "Ms. Rekha Singh",    "room": "102" }
  ///   ],
  ///   "Tuesday": [
  ///     { "time": "08:00 – 08:45", "subject": "Hindi",       "teacher": "Mr. Vinod Mishra",   "room": "103" },
  ///     { "time": "08:45 – 09:30", "subject": "S.Science",   "teacher": "Ms. Anita Gupta",    "room": "104" }
  ///   ]
  /// }
  /// ```
  @override
  Future<Map<String, List<TimetablePeriod>>> fetchTimetable(
      String classGrade, String section) async {
    final data = await _client.get(ApiEndpoints.timetable,
        queryParams: {'classGrade': classGrade, 'section': section});
    // API returns { "Monday": [...], "Tuesday": [...], ... }
    return data.map(
      (day, periods) => MapEntry(
        day,
        (periods as List)
            .map((p) => TimetablePeriod.fromJson(p as Map<String, dynamic>))
            .toList(),
      ),
    );
  }

  @override
  int periodsCountForDay(
      Map<String, List<TimetablePeriod>> timetable, String dayName) {
    return (timetable[dayName] ?? []).where((p) => !p.isBreak).length;
  }
}
