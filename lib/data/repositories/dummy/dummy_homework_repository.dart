import '../../dummy/dummy_data.dart';
import '../../models/homework_model.dart';
import '../../models/pending_homework_entry.dart';
import '../../models/roster_student.dart';
import '../homework_repository.dart';

/// In-memory implementation of [HomeworkRepository] backed by [DummyData].
///
/// Replace with [ApiHomeworkRepository] in [app.dart] when the backend is ready.
class DummyHomeworkRepository implements HomeworkRepository {
  @override
  Future<List<HomeworkItem>> fetchHomework(
      String classGrade, String section, String studentId) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return DummyData.homeworkFor(classGrade, section, studentId: studentId);
  }

  @override
  Future<void> saveSubmissions(String hwId, Set<String> submittedIds) async {
    DummyData.setSubmissions(hwId, submittedIds);
  }

  @override
  Future<Map<String, List<HomeworkItem>>> fetchHomeworkByTeacher(
      String teacherName) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return DummyData.homeworkByClassForTeacher(teacherName);
  }

  @override
  Future<List<RosterStudent>> fetchClassRoster(
      String classGrade, String section) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return DummyData.classRosterFor(classGrade, section);
  }

  @override
  Future<int> fetchSubmittedCount(
      String hwId, String classGrade, String section) async {
    return DummyData.submittedCountFor(hwId, classGrade, section);
  }

  @override
  Future<bool> fetchIsSubmittedBy(String hwId, String studentId) async {
    return DummyData.isSubmittedBy(hwId, studentId);
  }

  @override
  Future<List<PendingHomeworkEntry>> fetchPendingSubmissions(
      String classGrade, String section, {String? subjectFilter}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyData.pendingSubmissionsFor(classGrade, section,
        subjectFilter: subjectFilter);
  }
}
