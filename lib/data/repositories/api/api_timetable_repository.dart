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
