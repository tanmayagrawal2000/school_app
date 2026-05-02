import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../models/homework_model.dart';
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
    final list = await _client.getList(ApiEndpoints.homework,
        queryParams: {
          'classGrade': classGrade,
          'section': section,
          'studentId': studentId,
        });
    return list.map(HomeworkItem.fromJson).toList();
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
  }
}
