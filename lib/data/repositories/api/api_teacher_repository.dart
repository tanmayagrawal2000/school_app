import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../models/teacher_class_summary.dart';
import '../../models/teacher_model.dart';
import '../../models/timetable_model.dart';
import '../teacher_repository.dart';

/// Live API implementation of [TeacherRepository].
///
/// To activate, update [app.dart]:
/// ```dart
/// RepositoryProvider<TeacherRepository>(
///   create: (_) => ApiTeacherRepository(ApiClient()),
/// ),
/// ```
class ApiTeacherRepository implements TeacherRepository {
  final ApiClient _client;

  ApiTeacherRepository(this._client);

  /// GET `/teachers/me`
  ///
  /// Returns the profile of the currently authenticated teacher.
  ///
  /// Sample response:
  /// ```json
  /// {
  ///   "id": "t001",
  ///   "name": "Mr. Rajesh Kumar",
  ///   "subject": "Mathematics",
  ///   "classIncharge": "10-A",
  ///   "photoInitials": "RK",
  ///   "avatarColorIndex": 0
  /// }
  /// ```
  @override
  Future<TeacherModel> fetchCurrentTeacher() async {
    final json = await _client.get(ApiEndpoints.currentTeacher);
    return TeacherModel.fromJson(json as Map<String, dynamic>);
  }

  /// GET `/teachers/me/class-summaries?day=Monday`
  ///
  /// Returns class summaries (period count, attendance %, pending homework,
  /// subject averages) for every class the teacher is involved with on [dayName].
  ///
  /// Query params: `day` (e.g. `Monday`)
  ///
  /// Sample response:
  /// ```json
  /// [
  ///   {
  ///     "classGrade": "10",
  ///     "section": "A",
  ///     "subject": "Mathematics",
  ///     "isIncharge": true,
  ///     "todayPeriods": 2,
  ///     "attendancePercent": 87.5,
  ///     "pendingHomework": 3,
  ///     "classStats": { "classOverallAverage": 74.2, ... }
  ///   }
  /// ]
  /// ```
  @override
  Future<List<TeacherClassSummary>> fetchClassSummaries(
      TeacherModel teacher, String dayName) async {
    final json = await _client.get(
      ApiEndpoints.teacherClassSummaries,
      queryParams: {'day': dayName},
    );
    return (json as List)
        .map((e) => TeacherClassSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET `/teachers/me/schedule`
  ///
  /// Returns the teacher's weekly schedule as a day-keyed map.
  /// Each period's `teacher` field carries the class label (e.g. `"Class 10-A"`).
  ///
  /// Sample response:
  /// ```json
  /// {
  ///   "Monday": [
  ///     { "subject": "Mathematics", "time": "08:00 - 08:45", "room": "R-12",
  ///       "teacher": "Class 10-A", "isBreak": false }
  ///   ],
  ///   "Tuesday": []
  /// }
  /// ```
  @override
  Future<Map<String, List<TimetablePeriod>>> fetchSchedule(
      String teacherName) async {
    final json = await _client.get(ApiEndpoints.teacherSchedule);
    return (json as Map<String, dynamic>).map(
      (day, periods) => MapEntry(
        day,
        (periods as List)
            .map((p) => TimetablePeriod.fromJson(p as Map<String, dynamic>))
            .toList(),
      ),
    );
  }
}
