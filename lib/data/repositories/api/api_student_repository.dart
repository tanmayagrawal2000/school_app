import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../models/attendance_model.dart';
import '../../models/class_stats_model.dart';
import '../../models/fee_model.dart';
import '../../models/student_model.dart';
import '../../models/teacher_model.dart';
import '../student_repository.dart';

/// Live API implementation of [StudentRepository].
///
/// To activate, update [app.dart]:
/// ```dart
/// RepositoryProvider<StudentRepository>(
///   create: (_) => ApiStudentRepository(ApiClient()),
/// ),
/// ```
class ApiStudentRepository implements StudentRepository {
  final ApiClient _client;

  ApiStudentRepository(this._client);

  @override
  Future<StudentModel> fetchCurrentStudent() async {
    final data = await _client.get(ApiEndpoints.currentStudent);
    return StudentModel.fromJson(data);
  }

  @override
  Future<List<StudentModel>> fetchStudents() async {
    final list = await _client.getList(ApiEndpoints.students);
    return list.map(StudentModel.fromJson).toList();
  }

  @override
  Future<StudentModel?> fetchStudentById(String id) async {
    final data = await _client.get(ApiEndpoints.studentById(id));
    return StudentModel.fromJson(data);
  }

  @override
  Future<List<AttendanceRecord>> fetchAttendance(String studentId) async {
    final list =
        await _client.getList(ApiEndpoints.studentAttendance(studentId));
    return list.map(AttendanceRecord.fromJson).toList();
  }

  @override
  Future<TeacherModel?> fetchClassTeacher(
      String classGrade, String section) async {
    final data = await _client.get(ApiEndpoints.classTeacher,
        queryParams: {'classGrade': classGrade, 'section': section});
    return TeacherModel.fromJson(data);
  }

  @override
  Future<List<TeacherModel>> fetchSubjectTeachers(
      String classGrade, String section) async {
    final list = await _client.getList(ApiEndpoints.subjectTeachers,
        queryParams: {'classGrade': classGrade, 'section': section});
    return list.map(TeacherModel.fromJson).toList();
  }

  @override
  Future<ClassStats> fetchClassStats(String classGrade, String section) async {
    final data = await _client.get(ApiEndpoints.classStats,
        queryParams: {'classGrade': classGrade, 'section': section});
    return ClassStats.fromJson(data);
  }

  @override
  Future<List<FeeInstallment>> fetchFeeInstallments(String studentId) async {
    final list = await _client.getList(ApiEndpoints.studentFees(studentId));
    return list.map(FeeInstallment.fromJson).toList();
  }
}
