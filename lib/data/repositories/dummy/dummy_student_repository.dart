import '../../dummy/dummy_data.dart';
import '../../models/attendance_model.dart';
import '../../models/class_stats_model.dart';
import '../../models/fee_model.dart';
import '../../models/student_model.dart';
import '../../models/teacher_model.dart';
import '../student_repository.dart';

/// In-memory implementation of [StudentRepository] backed by [DummyData].
///
/// Replace with [ApiStudentRepository] in [app.dart] when the backend is ready.
class DummyStudentRepository implements StudentRepository {
  @override
  Future<List<StudentModel>> fetchStudents() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return DummyData.students;
  }

  @override
  Future<StudentModel?> fetchStudentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return DummyData.students.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<StudentModel> fetchCurrentStudent() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return DummyData.students.first;
  }

  @override
  Future<List<AttendanceRecord>> fetchAttendance(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final student = DummyData.students.where((s) => s.id == studentId).firstOrNull;
    return DummyData.generateAttendance(
      studentId,
      targetPercent: student?.attendancePercent ?? 85.0,
    );
  }

  @override
  Future<TeacherModel?> fetchClassTeacher(
      String classGrade, String section) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return DummyData.classTeacherFor(classGrade, section);
  }

  @override
  Future<List<TeacherModel>> fetchSubjectTeachers(
      String classGrade, String section) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return DummyData.subjectTeachersFor(classGrade, section);
  }

  @override
  Future<ClassStats> fetchClassStats(String classGrade, String section) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyData.classStatsFor(classGrade, section);
  }

  @override
  Future<List<FeeInstallment>> fetchFeeInstallments(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyData.feeInstallmentsFor(studentId);
  }
}
