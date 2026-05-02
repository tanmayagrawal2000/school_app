import '../models/homework_model.dart';
import '../models/pending_homework_entry.dart';
import '../models/roster_student.dart';

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

  /// Returns all homework grouped by class key (e.g. `"10-A"`) assigned by
  /// [teacherName].
  Future<Map<String, List<HomeworkItem>>> fetchHomeworkByTeacher(
      String teacherName);

  /// Returns the lightweight roster for [classGrade]-[section].
  Future<List<RosterStudent>> fetchClassRoster(
      String classGrade, String section);

  /// Returns the number of students who submitted [hwId] in
  /// [classGrade]-[section].
  Future<int> fetchSubmittedCount(
      String hwId, String classGrade, String section);

  /// Returns `true` if [studentId] has submitted [hwId].
  Future<bool> fetchIsSubmittedBy(String hwId, String studentId);

  /// Returns overdue homework entries for [classGrade]-[section].
  /// Optionally filtered to [subjectFilter] when provided.
  Future<List<PendingHomeworkEntry>> fetchPendingSubmissions(
      String classGrade, String section, {String? subjectFilter});
}
