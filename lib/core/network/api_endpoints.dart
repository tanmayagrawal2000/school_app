/// Central registry of every API endpoint path.
///
/// All paths are relative to [baseUrl].
/// Use named constructors (e.g. [studentById]) for parameterised routes.
class ApiEndpoints {
  ApiEndpoints._();

  /// Base URL for all API calls.
  /// Override via [ApiClient] constructor in non-production environments.
  static const String baseUrl = 'https://api.sgmschool.com/v1';

  // ── Auth ──────────────────────────────────────────────────────────────
  /// POST `/auth/login`
  /// Body: `{ "username": "aarav.sharma", "password": "secret", "role": "student" }`
  /// Response: `{ "accessToken": "eyJ...", "refreshToken": "eyJ...", "expiresIn": 3600 }`
  /// Valid role values: `student` | `parent` | `teacher`
  static const String login = '/auth/login';

  /// POST `/auth/logout`
  /// Body: `{ "refreshToken": "eyJ..." }`
  /// Response: `204 No Content`
  static const String logout = '/auth/logout';

  /// POST `/auth/refresh`
  /// Body: `{ "refreshToken": "eyJ..." }`
  /// Response: `{ "accessToken": "eyJ...", "expiresIn": 3600 }`
  static const String refreshToken = '/auth/refresh';

  // ── Current user ──────────────────────────────────────────────────────
  /// Logged-in student profile.
  static const String currentStudent = '/student/me';

  // ── Students ──────────────────────────────────────────────────────────
  static const String students = '/students';
  static String studentById(String id) => '/students/$id';
  static String studentAttendance(String studentId) =>
      '/students/$studentId/attendance';
  static String studentFees(String studentId) => '/students/$studentId/fees';

  // ── Teachers ──────────────────────────────────────────────────────────
  static const String classTeacher = '/teachers/class-teacher';
  static const String subjectTeachers = '/teachers/subject-teachers';

  // ── Academic ──────────────────────────────────────────────────────────
  static const String classStats = '/academic/class-stats';
  static const String timetable = '/academic/timetable';
  static const String homework = '/academic/homework';
  static String homeworkSubmissions(String hwId) =>
      '/academic/homework/$hwId/submissions';

  // ── Announcements ─────────────────────────────────────────────────────
  static const String announcements = '/announcements';
  static String announcementById(String id) => '/announcements/$id';

  // ── Bus ───────────────────────────────────────────────────────────────
  static const String busRoutes = '/bus/routes';
  static String busRouteById(String id) => '/bus/routes/$id';

  // ── Parents ───────────────────────────────────────────────────────────
  static String parentChildren(String parentId) => '/parents/$parentId/children';

  // ── Badges ────────────────────────────────────────────────────────────
  static const String badgeTypes = '/badge-types';
  static const String badges = '/badges';
  static String badgesForStudent(String studentId) =>
      '/students/$studentId/badges';
  static String badgeById(String id) => '/badges/$id';

  // ── Teacher ───────────────────────────────────────────────────────────
  /// GET `/teachers/me`
  static const String currentTeacher = '/teachers/me';

  /// GET `/teachers/me/class-summaries?day=Monday`
  static const String teacherClassSummaries = '/teachers/me/class-summaries';

  /// GET `/teachers/me/schedule`
  static const String teacherSchedule = '/teachers/me/schedule';

  // ── Reminders ─────────────────────────────────────────────────────────
  /// GET `/reminders?day=Monday`
  static const String reminders = '/reminders';

  // ── Class-level academic data ──────────────────────────────────────────
  /// GET `/academic/class-attendance?grade=10&section=A`
  static const String classAttendanceSummary = '/academic/class-attendance';

  /// GET `/academic/subject-marks?grade=10&section=A&subject=Mathematics`
  static const String subjectMarks = '/academic/subject-marks';

  /// GET `/academic/pending-submissions?grade=10&section=A`
  static const String pendingSubmissions = '/academic/pending-submissions';

  /// GET `/academic/homework/by-teacher?teacherName=...`
  static const String homeworkByTeacher = '/academic/homework/by-teacher';

  /// GET `/classes/{grade}/{section}/roster`
  static String classRoster(String grade, String section) =>
      '/classes/$grade/$section/roster';

  /// GET `/academic/homework/{hwId}/submission-count?grade=10&section=A`
  static String homeworkSubmissionCount(String hwId) =>
      '/academic/homework/$hwId/submission-count';

  /// GET `/academic/homework/{hwId}/submitted/{studentId}`
  static String homeworkSubmittedBy(String hwId, String studentId) =>
      '/academic/homework/$hwId/submitted/$studentId';

  /// GET `/parents/{parentId}`
  static String parentById(String parentId) => '/parents/$parentId';
}
