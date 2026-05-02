class _CacheEntry {
  final dynamic data;
  final DateTime fetchedAt;
  _CacheEntry(this.data, this.fetchedAt);
}

/// In-memory TTL cache used by the API repository layer.
///
/// The dummy repositories do not use this cache — they always read from
/// in-memory [DummyData].  The API repositories check the cache before
/// issuing a network request and store the response after a successful fetch.
///
/// Every BLoC refresh handler should call [AppCache.clear] so a
/// pull-to-refresh always bypasses the cache and hits the live API.
class AppCache {
  AppCache._();

  static final Map<String, _CacheEntry> _store = {};

  // ── TTLs ──────────────────────────────────────────────────────────────────
  /// Homework, announcements, attendance records.
  static const Duration shortTtl = Duration(minutes: 5);

  /// Student profile, fees, class stats, roster.
  static const Duration mediumTtl = Duration(minutes: 10);

  /// Timetable, teacher schedule — rarely changes during the school day.
  static const Duration longTtl = Duration(minutes: 30);

  // ── Core operations ───────────────────────────────────────────────────────

  static T? get<T>(String key, Duration ttl) {
    final entry = _store[key];
    if (entry == null) return null;
    if (DateTime.now().difference(entry.fetchedAt) > ttl) {
      _store.remove(key);
      return null;
    }
    return entry.data as T?;
  }

  static void set(String key, dynamic value) =>
      _store[key] = _CacheEntry(value, DateTime.now());

  static void invalidate(String key) => _store.remove(key);

  static void invalidateWhere(bool Function(String key) test) =>
      _store.removeWhere((k, _) => test(k));

  /// Wipes the entire cache. Call this in every BLoC refresh handler so that
  /// pull-to-refresh always returns fresh data from the API.
  static void clear() => _store.clear();

  // ── Cache keys ────────────────────────────────────────────────────────────

  static String currentStudent() => 'student:me';
  static String studentById(String id) => 'student:$id';
  static String students() => 'students:all';
  static String classTeacher(String g, String s) => 'class_teacher:$g:$s';
  static String subjectTeachers(String g, String s) => 'subject_teachers:$g:$s';
  static String classStats(String g, String s) => 'class_stats:$g:$s';
  static String feeInstallments(String id) => 'fees:$id';
  static String attendance(String id) => 'attendance:$id';
  static String children(String parentId) => 'children:$parentId';
  static String parent(String parentId) => 'parent:$parentId';
  static String classAttendance(String g, String s) => 'class_attendance:$g:$s';
  static String classAvgAttendance(String g, String s) => 'class_avg:$g:$s';
  static String subjectMarks(String g, String s, String sub) =>
      'subject_marks:$g:$s:$sub';
  static String timetable(String g, String s) => 'timetable:$g:$s';
  static String homework(String g, String s, String sId) => 'hw:$g:$s:$sId';
  static String homeworkByTeacher(String name) => 'hw_teacher:$name';
  static String classRoster(String g, String s) => 'roster:$g:$s';
  static String submittedCount(String hwId, String g, String s) =>
      'sub_count:$hwId:$g:$s';
  static String isSubmittedBy(String hwId, String sId) => 'is_sub:$hwId:$sId';
  static String pendingSubmissions(String g, String s, String? sub) =>
      'pending:$g:$s:${sub ?? "all"}';
  static String announcements() => 'announcements';
  static String currentTeacher() => 'teacher:me';
  static String teacherClasses(String name, String day) =>
      'teacher_classes:$name:$day';
  static String teacherSchedule(String name) => 'teacher_schedule:$name';
  static String reminders(String day) => 'reminders:$day';
}
