import '../../dummy/dummy_data.dart';
import '../../models/teacher_class_summary.dart';
import '../../models/teacher_model.dart';
import '../../models/timetable_model.dart';
import '../teacher_repository.dart';

/// In-memory implementation of [TeacherRepository] backed by [DummyData].
///
/// Replace with [ApiTeacherRepository] in [app.dart] when the backend is ready.
class DummyTeacherRepository implements TeacherRepository {
  @override
  Future<TeacherModel> fetchCurrentTeacher() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return DummyData.currentTeacher;
  }

  @override
  Future<List<TeacherClassSummary>> fetchClassSummaries(
      TeacherModel teacher, String dayName) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyData.teacherClassSummaries(teacher, dayName);
  }

  @override
  Future<Map<String, List<TimetablePeriod>>> fetchSchedule(
      String teacherName) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyData.teacherSchedule(teacherName);
  }
}
