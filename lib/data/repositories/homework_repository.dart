import '../models/homework_model.dart';

/// Contract for homework data operations.
///
/// Swap implementations in [app.dart]:
/// - [DummyHomeworkRepository] — in-memory data, no network required.
/// - [ApiHomeworkRepository]   — live backend via [ApiClient].
abstract class HomeworkRepository {
  /// Returns homework for [classGrade]-[section] with [isSubmitted] reflecting
  /// what the teacher has marked for [studentId].
  Future<List<HomeworkItem>> fetchHomework(
      String classGrade, String section, String studentId);

  /// Saves the complete submission list for [hwId] in one call.
  /// [submittedIds] is the full set of student IDs the teacher has marked.
  /// On the live API this calls:
  ///   PUT /academic/homework/{hwId}/submissions
  ///   Body: { "submittedStudentIds": ["s001", "r_10a_2", ...] }
  Future<void> saveSubmissions(String hwId, Set<String> submittedIds);
}
