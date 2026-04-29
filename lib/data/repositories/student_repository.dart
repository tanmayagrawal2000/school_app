import '../models/attendance_model.dart';
import '../models/class_stats_model.dart';
import '../models/fee_model.dart';
import '../models/student_model.dart';
import '../models/teacher_model.dart';

/// Contract for all student-related data operations.
///
/// Swap implementations in [app.dart]:
/// - [DummyStudentRepository] — in-memory data, no network required.
/// - [ApiStudentRepository]   — live backend via [ApiClient].
abstract class StudentRepository {
  /// Returns all students visible to the current user.
  Future<List<StudentModel>> fetchStudents();

  /// Returns a single student by [id], or `null` if not found.
  Future<StudentModel?> fetchStudentById(String id);

  /// Returns the currently authenticated student.
  Future<StudentModel> fetchCurrentStudent();

  /// Returns all attendance records for [studentId].
  Future<List<AttendanceRecord>> fetchAttendance(String studentId);

  /// Returns the class teacher for [classGrade]-[section].
  Future<TeacherModel?> fetchClassTeacher(String classGrade, String section);

  /// Returns all subject teachers for [classGrade]-[section].
  Future<List<TeacherModel>> fetchSubjectTeachers(
      String classGrade, String section);

  /// Returns class-wide statistics for [classGrade]-[section],
  /// including the student's rank and per-subject averages.
  Future<ClassStats> fetchClassStats(String classGrade, String section);

  /// Returns fee installments for [studentId].
  Future<List<FeeInstallment>> fetchFeeInstallments(String studentId);
}
