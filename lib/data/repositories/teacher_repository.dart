import '../models/teacher_class_summary.dart';
import '../models/teacher_model.dart';
import '../models/timetable_model.dart';

/// Contract for all teacher-related data operations.
///
/// Swap implementations in [app.dart]:
/// - [DummyTeacherRepository] — in-memory data, no network required.
/// - [ApiTeacherRepository]   — live backend via [ApiClient].
abstract class TeacherRepository {
  /// Returns the currently authenticated teacher.
  Future<TeacherModel> fetchCurrentTeacher();

  /// Returns the class summary list for [teacher] on [dayName].
  Future<List<TeacherClassSummary>> fetchClassSummaries(
      TeacherModel teacher, String dayName);

  /// Returns the weekly schedule (day → periods) for [teacherName].
  Future<Map<String, List<TimetablePeriod>>> fetchSchedule(String teacherName);
}
