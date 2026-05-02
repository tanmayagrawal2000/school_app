import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../models/attendance_model.dart';
import '../../models/class_stats_model.dart';
import '../../models/fee_model.dart';
import '../../models/parent_model.dart';
import '../../models/student_attendance_summary.dart';
import '../../models/student_model.dart';
import '../../models/student_subject_mark.dart';
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

  /// GET `/student/me`
  ///
  /// Returns the profile of the currently authenticated student.
  /// The student identity is derived from the auth token — no request params needed.
  ///
  /// Sample response:
  /// ```json
  /// {
  ///   "id": "s001",
  ///   "name": "Aarav Sharma",
  ///   "admissionNo": "SGM-2021-001",
  ///   "rollNo": 1,
  ///   "classGrade": "10",
  ///   "section": "A",
  ///   "dateOfBirth": "2008-03-15",
  ///   "gender": "Male",
  ///   "bloodGroup": "B+",
  ///   "fatherName": "Rajesh Sharma",
  ///   "motherName": "Priya Sharma",
  ///   "contactNumber": "9876543210",
  ///   "address": "12, Civil Lines, Kanpur",
  ///   "busRoute": "Route 1",
  ///   "busNumber": "KA-01-1234",
  ///   "attendancePercent": 91.5,
  ///   "house": "Red House",
  ///   "photoInitials": "AS",
  ///   "avatarColorIndex": 0,
  ///   "results": [
  ///     { "subject": "Mathematics", "maxMarks": 100, "obtainedMarks": 92, "grade": "A1" },
  ///     { "subject": "Science",     "maxMarks": 100, "obtainedMarks": 85, "grade": "A2" }
  ///   ],
  ///   "feeStatus": "paid",
  ///   "totalFee": 45000.0,
  ///   "paidFee": 45000.0
  /// }
  /// ```
  @override
  Future<StudentModel> fetchCurrentStudent() async {
    final data = await _client.get(ApiEndpoints.currentStudent);
    return StudentModel.fromJson(data);
  }

  /// GET `/students`
  ///
  /// Returns all students. Used by teachers on the Student List screen.
  /// No request parameters — server scopes results to the teacher's classes via auth token.
  ///
  /// Sample response:
  /// ```json
  /// [
  ///   {
  ///     "id": "s001",
  ///     "name": "Aarav Sharma",
  ///     "admissionNo": "SGM-2021-001",
  ///     "rollNo": 1,
  ///     "classGrade": "10",
  ///     "section": "A",
  ///     "dateOfBirth": "2008-03-15",
  ///     "gender": "Male",
  ///     "bloodGroup": "B+",
  ///     "fatherName": "Rajesh Sharma",
  ///     "motherName": "Priya Sharma",
  ///     "contactNumber": "9876543210",
  ///     "address": "12, Civil Lines, Kanpur",
  ///     "busRoute": "Route 1",
  ///     "busNumber": "KA-01-1234",
  ///     "attendancePercent": 91.5,
  ///     "house": "Red House",
  ///     "photoInitials": "AS",
  ///     "avatarColorIndex": 0,
  ///     "results": [
  ///       { "subject": "Mathematics", "maxMarks": 100, "obtainedMarks": 92, "grade": "A1" }
  ///     ],
  ///     "feeStatus": "paid",
  ///     "totalFee": 45000.0,
  ///     "paidFee": 45000.0
  ///   }
  /// ]
  /// ```
  @override
  Future<List<StudentModel>> fetchStudents() async {
    final list = await _client.getList(ApiEndpoints.students);
    return list.map(StudentModel.fromJson).toList();
  }

  /// GET `/students/{id}`
  ///
  /// Sample input: `id = "s001"`
  ///
  /// Sample response:
  /// ```json
  /// {
  ///   "id": "s001",
  ///   "name": "Aarav Sharma",
  ///   "admissionNo": "SGM-2021-001",
  ///   "rollNo": 1,
  ///   "classGrade": "10",
  ///   "section": "A",
  ///   "dateOfBirth": "2008-03-15",
  ///   "gender": "Male",
  ///   "bloodGroup": "B+",
  ///   "fatherName": "Rajesh Sharma",
  ///   "motherName": "Priya Sharma",
  ///   "contactNumber": "9876543210",
  ///   "address": "12, Civil Lines, Kanpur",
  ///   "busRoute": "Route 1",
  ///   "busNumber": "KA-01-1234",
  ///   "attendancePercent": 91.5,
  ///   "house": "Red House",
  ///   "photoInitials": "AS",
  ///   "avatarColorIndex": 0,
  ///   "results": [
  ///     { "subject": "Mathematics", "maxMarks": 100, "obtainedMarks": 92, "grade": "A1" },
  ///     { "subject": "Science",     "maxMarks": 100, "obtainedMarks": 85, "grade": "A2" }
  ///   ],
  ///   "feeStatus": "paid",
  ///   "totalFee": 45000.0,
  ///   "paidFee": 45000.0
  /// }
  /// ```
  @override
  Future<StudentModel?> fetchStudentById(String id) async {
    final data = await _client.get(ApiEndpoints.studentById(id));
    return StudentModel.fromJson(data);
  }

  /// GET `/students/{studentId}/attendance`
  ///
  /// Sample input: `studentId = "s001"`
  ///
  /// Sample response:
  /// ```json
  /// [
  ///   { "date": "2026-04-01T00:00:00.000Z", "status": "present" },
  ///   { "date": "2026-04-02T00:00:00.000Z", "status": "absent"  },
  ///   { "date": "2026-04-03T00:00:00.000Z", "status": "late"    },
  ///   { "date": "2026-04-04T00:00:00.000Z", "status": "holiday" },
  ///   { "date": "2026-04-05T00:00:00.000Z", "status": "sunday"  }
  /// ]
  /// ```
  /// Valid status values: `present` | `absent` | `late` | `holiday` | `sunday`
  @override
  Future<List<AttendanceRecord>> fetchAttendance(String studentId) async {
    final list =
        await _client.getList(ApiEndpoints.studentAttendance(studentId));
    return list.map(AttendanceRecord.fromJson).toList();
  }

  /// GET `/teachers/class-teacher?classGrade={classGrade}&section={section}`
  ///
  /// Sample input: `classGrade = "10"`, `section = "A"`
  ///
  /// Sample response:
  /// ```json
  /// {
  ///   "id": "t001",
  ///   "name": "Mrs. Sunita Verma",
  ///   "employeeId": "EMP-101",
  ///   "subject": "Mathematics",
  ///   "classIncharge": "Class 10-A",
  ///   "qualification": "M.Sc., B.Ed.",
  ///   "contactNumber": "9812345678",
  ///   "experience": 12,
  ///   "photoInitials": "SV",
  ///   "avatarColorIndex": 2
  /// }
  /// ```
  @override
  Future<TeacherModel?> fetchClassTeacher(
      String classGrade, String section) async {
    final data = await _client.get(ApiEndpoints.classTeacher,
        queryParams: {'classGrade': classGrade, 'section': section});
    return TeacherModel.fromJson(data);
  }

  /// GET `/teachers/subject-teachers?classGrade={classGrade}&section={section}`
  ///
  /// Sample input: `classGrade = "10"`, `section = "A"`
  ///
  /// Sample response:
  /// ```json
  /// [
  ///   {
  ///     "id": "t002",
  ///     "name": "Mr. Anil Kumar",
  ///     "employeeId": "EMP-102",
  ///     "subject": "Science",
  ///     "classIncharge": "Class 9-B",
  ///     "qualification": "M.Sc., B.Ed.",
  ///     "contactNumber": "9823456789",
  ///     "experience": 8,
  ///     "photoInitials": "AK",
  ///     "avatarColorIndex": 1
  ///   },
  ///   {
  ///     "id": "t003",
  ///     "name": "Ms. Rekha Singh",
  ///     "employeeId": "EMP-103",
  ///     "subject": "English",
  ///     "classIncharge": "Class 10-B",
  ///     "qualification": "M.A., B.Ed.",
  ///     "contactNumber": "9834567890",
  ///     "experience": 5,
  ///     "photoInitials": "RS",
  ///     "avatarColorIndex": 3
  ///   }
  /// ]
  /// ```
  @override
  Future<List<TeacherModel>> fetchSubjectTeachers(
      String classGrade, String section) async {
    final list = await _client.getList(ApiEndpoints.subjectTeachers,
        queryParams: {'classGrade': classGrade, 'section': section});
    return list.map(TeacherModel.fromJson).toList();
  }

  /// GET `/academic/class-stats?classGrade={classGrade}&section={section}`
  ///
  /// Sample input: `classGrade = "10"`, `section = "A"`
  ///
  /// Sample response:
  /// ```json
  /// {
  ///   "classGrade": "10",
  ///   "section": "A",
  ///   "totalStudents": 42,
  ///   "studentRank": 5,
  ///   "classOverallAverage": 74.3,
  ///   "subjects": [
  ///     { "subject": "Mathematics", "classAverage": 71.2, "topperMarks": 98 },
  ///     { "subject": "Science",     "classAverage": 76.8, "topperMarks": 95 },
  ///     { "subject": "English",     "classAverage": 78.5, "topperMarks": 97 },
  ///     { "subject": "Hindi",       "classAverage": 80.1, "topperMarks": 96 },
  ///     { "subject": "S.Science",   "classAverage": 73.4, "topperMarks": 94 }
  ///   ]
  /// }
  /// ```
  @override
  Future<ClassStats> fetchClassStats(String classGrade, String section) async {
    final data = await _client.get(ApiEndpoints.classStats,
        queryParams: {'classGrade': classGrade, 'section': section});
    return ClassStats.fromJson(data);
  }

  /// GET `/students/{studentId}/fees`
  ///
  /// Sample input: `studentId = "s001"`
  ///
  /// Sample response:
  /// ```json
  /// [
  ///   {
  ///     "term": "Q1",
  ///     "period": "Apr – Jun 2025",
  ///     "amount": 11250.0,
  ///     "status": "paid",
  ///     "dueDate": "2025-04-10T00:00:00.000Z",
  ///     "paidDate": "2025-04-08T00:00:00.000Z"
  ///   },
  ///   {
  ///     "term": "Q2",
  ///     "period": "Jul – Sep 2025",
  ///     "amount": 11250.0,
  ///     "status": "pending",
  ///     "dueDate": "2025-07-10T00:00:00.000Z",
  ///     "paidDate": null
  ///   },
  ///   {
  ///     "term": "Q3",
  ///     "period": "Oct – Dec 2025",
  ///     "amount": 11250.0,
  ///     "status": "overdue",
  ///     "dueDate": "2025-10-10T00:00:00.000Z",
  ///     "paidDate": null
  ///   },
  ///   {
  ///     "term": "Q4",
  ///     "period": "Jan – Mar 2026",
  ///     "amount": 11250.0,
  ///     "status": "partial",
  ///     "dueDate": "2026-01-10T00:00:00.000Z",
  ///     "paidDate": null
  ///   }
  /// ]
  /// ```
  /// Valid status values: `paid` | `pending` | `overdue` | `partial`
  @override
  Future<List<FeeInstallment>> fetchFeeInstallments(String studentId) async {
    final list = await _client.getList(ApiEndpoints.studentFees(studentId));
    return list.map(FeeInstallment.fromJson).toList();
  }

  /// GET `/parents/{parentId}/children`
  ///
  /// Sample input: `parentId = "p001"`
  ///
  /// Sample response: same schema as [fetchStudents] — array of [StudentModel] objects.
  /// ```json
  /// [
  ///   {
  ///     "id": "s001",
  ///     "name": "Aarav Sharma",
  ///     "admissionNo": "SGM-2021-001",
  ///     "rollNo": 1,
  ///     "classGrade": "10",
  ///     "section": "A",
  ///     "attendancePercent": 91.5,
  ///     "feeStatus": "paid",
  ///     "totalFee": 45000.0,
  ///     "paidFee": 45000.0
  ///   }
  /// ]
  /// ```
  @override
  Future<List<StudentModel>> fetchChildrenForParent(String parentId) async {
    final list = await _client.getList(ApiEndpoints.parentChildren(parentId));
    return list.map(StudentModel.fromJson).toList();
  }

  /// GET `/parents/{parentId}`
  ///
  /// Sample input: `parentId = "p001"`
  ///
  /// Sample response:
  /// ```json
  /// {
  ///   "id": "p001",
  ///   "name": "Rakesh Sharma",
  ///   "childrenIds": ["s001"]
  /// }
  /// ```
  @override
  Future<ParentModel?> fetchParent(String parentId) async {
    final json = await _client.get(ApiEndpoints.parentById(parentId));
    if (json == null) return null;
    return ParentModel.fromJson(json as Map<String, dynamic>);
  }

  /// GET `/academic/class-attendance?grade={classGrade}&section={section}`
  ///
  /// Returns per-student attendance summary for the entire class.
  ///
  /// Sample input: `classGrade = "10"`, `section = "A"`
  ///
  /// Sample response:
  /// ```json
  /// [
  ///   {
  ///     "studentId": "s001",
  ///     "name": "Arjun Sharma",
  ///     "photoInitials": "AS",
  ///     "avatarColorIndex": 0,
  ///     "presentDays": 84,
  ///     "absentDays": 7,
  ///     "lateDays": 1,
  ///     "totalWorkingDays": 92,
  ///     "percentage": 91.3
  ///   }
  /// ]
  /// ```
  @override
  Future<List<StudentAttendanceSummary>> fetchClassAttendanceSummary(
      String classGrade, String section) async {
    final list = await _client.getList(
      ApiEndpoints.classAttendanceSummary,
      queryParams: {'grade': classGrade, 'section': section},
    );
    return list
        .map((e) => StudentAttendanceSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET `/academic/class-attendance?grade={classGrade}&section={section}`
  ///
  /// Returns the average attendance percentage derived from the list response.
  @override
  Future<double> fetchClassAvgAttendance(
      String classGrade, String section) async {
    final summaries = await fetchClassAttendanceSummary(classGrade, section);
    if (summaries.isEmpty) return 0.0;
    return summaries.map((s) => s.percentage).reduce((a, b) => a + b) /
        summaries.length;
  }

  /// GET `/academic/subject-marks?grade={classGrade}&section={section}&subject={subject}`
  ///
  /// Returns per-student marks for [subject] sorted worst→best by percentage.
  ///
  /// Sample input: `classGrade = "10"`, `section = "A"`, `subject = "Mathematics"`
  ///
  /// Sample response:
  /// ```json
  /// [
  ///   {
  ///     "studentId": "s003",
  ///     "name": "Rahul Gupta",
  ///     "photoInitials": "RG",
  ///     "avatarColorIndex": 2,
  ///     "marks": 62,
  ///     "maxMarks": 100,
  ///     "grade": "B2",
  ///     "percentage": 62.0
  ///   }
  /// ]
  /// ```
  @override
  Future<List<StudentSubjectMark>> fetchSubjectMarks(
      String classGrade, String section, String subject) async {
    final list = await _client.getList(
      ApiEndpoints.subjectMarks,
      queryParams: {
        'grade': classGrade,
        'section': section,
        'subject': subject,
      },
    );
    return list
        .map((e) => StudentSubjectMark.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
