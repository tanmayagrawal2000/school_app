import '../../../core/cache/app_cache.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../models/homework_model.dart';
import '../../models/pending_homework_entry.dart';
import '../../models/roster_student.dart';
import '../homework_repository.dart';

/// Live API implementation of [HomeworkRepository].
///
/// To activate, update [app.dart]:
/// ```dart
/// RepositoryProvider<HomeworkRepository>(
///   create: (_) => ApiHomeworkRepository(ApiClient()),
/// ),
/// ```
class ApiHomeworkRepository implements HomeworkRepository {
  final ApiClient _client;

  ApiHomeworkRepository(this._client);

  /// GET `/academic/homework?classGrade={classGrade}&section={section}&studentId={studentId}`
  ///
  /// Sample input: `classGrade = "10"`, `section = "A"`, `studentId = "s001"`
  ///
  /// The `isSubmitted` flag is resolved per-student by the server using `studentId`.
  /// Valid priority values: `high` | `medium` | `low`
  ///
  /// Sample response:
  /// ```json
  /// [
  ///   {
  ///     "id": "hw001",
  ///     "subject": "Mathematics",
  ///     "teacherName": "Mrs. Sunita Verma",
  ///     "title": "Quadratic Equations – Practice Set 3",
  ///     "description": "Complete exercises 3.1 to 3.5 from the NCERT textbook.",
  ///     "dueDate": "2026-05-05T00:00:00.000Z",
  ///     "isSubmitted": false,
  ///     "priority": "high"
  ///   },
  ///   {
  ///     "id": "hw002",
  ///     "subject": "Science",
  ///     "teacherName": "Mr. Anil Kumar",
  ///     "title": "Light Reflection – Diagram Worksheet",
  ///     "description": "Draw and label ray diagrams for concave and convex mirrors.",
  ///     "dueDate": "2026-05-08T00:00:00.000Z",
  ///     "isSubmitted": true,
  ///     "priority": "medium"
  ///   }
  /// ]
  /// ```
  @override
  Future<List<HomeworkItem>> fetchHomework(
      String classGrade, String section, String studentId) async {
    final key = AppCache.homework(classGrade, section, studentId);
    final cached = AppCache.get<List<HomeworkItem>>(key, AppCache.shortTtl);
    if (cached != null) return cached;

    final list = await _client.getList(ApiEndpoints.homework,
        queryParams: {
          'classGrade': classGrade,
          'section': section,
          'studentId': studentId,
        });
    final result = list.map(HomeworkItem.fromJson).toList();
    AppCache.set(key, result);
    return result;
  }

  /// PUT `/academic/homework/{hwId}/submissions`
  ///
  /// Replaces the entire submission set for a homework item atomically.
  /// Called once when the teacher taps Save on the mark-submissions screen.
  ///
  /// Sample input: `hwId = "hw001"`, `submittedIds = {"s001", "s003", "s007"}`
  ///
  /// Sample request body:
  /// ```json
  /// {
  ///   "submittedStudentIds": ["s001", "s003", "s007"]
  /// }
  /// ```
  ///
  /// Sample response: `204 No Content` (empty body on success).
  @override
  Future<void> saveSubmissions(String hwId, Set<String> submittedIds) async {
    await _client.put(
      ApiEndpoints.homeworkSubmissions(hwId),
      body: {'submittedStudentIds': submittedIds.toList()},
    );
    // Invalidate submission-related cache entries for this homework.
    AppCache.invalidateWhere((k) => k.contains(hwId));
  }

  /// GET `/academic/homework/by-teacher?teacherName={teacherName}`
  ///
  /// Returns homework grouped by class key (e.g. `"10-A"`) for the teacher.
  ///
  /// Sample response:
  /// ```json
  /// {
  ///   "10-A": [
  ///     { "id": "hw001", "subject": "Mathematics", "title": "...",
  ///       "dueDate": "2026-05-05T00:00:00.000Z", "priority": "high" }
  ///   ],
  ///   "11-B": []
  /// }
  /// ```
  @override
  Future<Map<String, List<HomeworkItem>>> fetchHomeworkByTeacher(
      String teacherName) async {
    final key = AppCache.homeworkByTeacher(teacherName);
    final cached = AppCache.get<Map<String, List<HomeworkItem>>>(key, AppCache.shortTtl);
    if (cached != null) return cached;

    final json = await _client.get(
      ApiEndpoints.homeworkByTeacher,
      queryParams: {'teacherName': teacherName},
    );
    final result = json.map(
      (cls, value) => MapEntry(
        cls,
        (value as List)
            .map((e) => HomeworkItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
    AppCache.set(key, result);
    return result;
  }

  /// GET `/classes/{grade}/{section}/roster`
  ///
  /// Returns the lightweight student roster for a class.
  ///
  /// Sample response:
  /// ```json
  /// [
  ///   { "id": "r_10a_1", "name": "Aarav Sharma", "photoInitials": "AS",
  ///     "avatarColorIndex": 0 }
  /// ]
  /// ```
  @override
  Future<List<RosterStudent>> fetchClassRoster(
      String classGrade, String section) async {
    final key = AppCache.classRoster(classGrade, section);
    final cached = AppCache.get<List<RosterStudent>>(key, AppCache.mediumTtl);
    if (cached != null) return cached;

    final list = await _client.getList(
        ApiEndpoints.classRoster(classGrade, section));
    final result = list.map(RosterStudent.fromJson).toList();
    AppCache.set(key, result);
    return result;
  }

  /// GET `/academic/homework/{hwId}/submission-count?grade={grade}&section={section}`
  ///
  /// Sample response: `{ "count": 24 }`
  @override
  Future<int> fetchSubmittedCount(
      String hwId, String classGrade, String section) async {
    final key = AppCache.submittedCount(hwId, classGrade, section);
    final cached = AppCache.get<int>(key, AppCache.shortTtl);
    if (cached != null) return cached;

    final json = await _client.get(
      ApiEndpoints.homeworkSubmissionCount(hwId),
      queryParams: {'grade': classGrade, 'section': section},
    );
    final result = json['count'] as int;
    AppCache.set(key, result);
    return result;
  }

  /// GET `/academic/homework/{hwId}/submitted/{studentId}`
  ///
  /// Sample response: `{ "submitted": true }`
  @override
  Future<bool> fetchIsSubmittedBy(String hwId, String studentId) async {
    final key = AppCache.isSubmittedBy(hwId, studentId);
    final cached = AppCache.get<bool>(key, AppCache.shortTtl);
    if (cached != null) return cached;

    final json = await _client.get(
        ApiEndpoints.homeworkSubmittedBy(hwId, studentId));
    final result = json['submitted'] as bool;
    AppCache.set(key, result);
    return result;
  }

  /// GET `/academic/pending-submissions?grade={grade}&section={section}&subject={subject}`
  ///
  /// Returns overdue homework entries with per-student submission status.
  ///
  /// Sample response:
  /// ```json
  /// [
  ///   {
  ///     "homework": { "id": "hw001", "subject": "Mathematics", "title": "...",
  ///                   "dueDate": "2026-04-20T00:00:00.000Z", "priority": "high" },
  ///     "totalStudents": 30,
  ///     "submittedCount": 22,
  ///     "missingCount": 8,
  ///     "notSubmitted": [
  ///       { "id": "r_10a_3", "name": "Rahul Gupta", "photoInitials": "RG",
  ///         "avatarColorIndex": 2 }
  ///     ]
  ///   }
  /// ]
  /// ```
  @override
  Future<List<PendingHomeworkEntry>> fetchPendingSubmissions(
      String classGrade, String section, {String? subjectFilter}) async {
    final key = AppCache.pendingSubmissions(classGrade, section, subjectFilter);
    final cached = AppCache.get<List<PendingHomeworkEntry>>(key, AppCache.shortTtl);
    if (cached != null) return cached;

    final params = <String, String>{
      'grade': classGrade,
      'section': section,
    };
    if (subjectFilter != null) params['subject'] = subjectFilter;
    final list = await _client.getList(
        ApiEndpoints.pendingSubmissions, queryParams: params);
    final result = list.map(PendingHomeworkEntry.fromJson).toList();
    AppCache.set(key, result);
    return result;
  }
}
