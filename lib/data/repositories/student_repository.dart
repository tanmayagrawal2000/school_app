import '../models/attendance_model.dart';
import '../models/class_stats_model.dart';
import '../models/fee_model.dart';
import '../models/parent_model.dart';
import '../models/student_attendance_summary.dart';
import '../models/student_model.dart';
import '../models/student_subject_mark.dart';
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

  /// Returns all children linked to a parent account by [parentId].
  Future<List<StudentModel>> fetchChildrenForParent(String parentId);

  /// Returns the parent record for [parentId], or `null` if not found.
  Future<ParentModel?> fetchParent(String parentId);

  /// Returns attendance summaries for every student in [classGrade]-[section].
  Future<List<StudentAttendanceSummary>> fetchClassAttendanceSummary(
      String classGrade, String section);

  /// Returns the average attendance percentage for [classGrade]-[section].
  Future<double> fetchClassAvgAttendance(String classGrade, String section);

  /// Returns per-student marks for [subject] in [classGrade]-[section],
  /// sorted worst→best by percentage.
  Future<List<StudentSubjectMark>> fetchSubjectMarks(
      String classGrade, String section, String subject);
}
