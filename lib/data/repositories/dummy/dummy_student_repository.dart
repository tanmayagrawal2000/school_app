import '../../dummy/dummy_data.dart';
import '../../models/attendance_model.dart';
import '../../models/class_stats_model.dart';
import '../../models/fee_model.dart';
import '../../models/parent_model.dart';
import '../../models/student_attendance_summary.dart';
import '../../models/student_model.dart';
import '../../models/student_subject_mark.dart';
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

  @override
  Future<List<StudentModel>> fetchChildrenForParent(String parentId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return DummyData.childrenForParent(parentId);
  }

  @override
  Future<ParentModel?> fetchParent(String parentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return DummyData.parentFor(parentId);
  }

  @override
  Future<List<StudentAttendanceSummary>> fetchClassAttendanceSummary(
      String classGrade, String section) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return DummyData.classStudentAttendance(classGrade, section);
  }

  @override
  Future<double> fetchClassAvgAttendance(
      String classGrade, String section) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return DummyData.classAvgAttendancePct(classGrade, section);
  }

  @override
  Future<List<StudentSubjectMark>> fetchSubjectMarks(
      String classGrade, String section, String subject) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return DummyData.subjectMarksFor(classGrade, section, subject);
  }
}
