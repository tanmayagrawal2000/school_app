import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/enums/user_role.dart';
import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/student_model.dart';
import '../../../data/models/teacher_model.dart';
import '../../../data/repositories/announcement_repository.dart';
import '../../../data/repositories/reminder_repository.dart';
import '../../../data/repositories/student_repository.dart';
import '../../../data/repositories/teacher_repository.dart';
import '../../../data/repositories/timetable_repository.dart';
import '../../../data/models/teacher_class_summary.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final StudentRepository _studentRepo;
  final TimetableRepository _timetableRepo;
  final AnnouncementRepository _announcementRepo;
  final TeacherRepository _teacherRepo;
  final ReminderRepository _reminderRepo;

  HomeBloc(
    this._studentRepo,
    this._timetableRepo,
    this._announcementRepo,
    this._teacherRepo,
    this._reminderRepo,
  ) : super(HomeInitial()) {
    on<HomeFetchDashboard>(_onFetchDashboard);
    on<HomeMarkAnnouncementRead>(_onMarkRead);
    on<HomeSelectChild>(_onSelectChild);
  }

  Future<void> _onFetchDashboard(
    HomeFetchDashboard event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    StudentModel? currentStudent;
    TeacherModel? classTeacher;
    TeacherModel? currentTeacher;
    List<TeacherModel> subjectTeachers = [];
    int todayPeriods = 0;
    int tomorrowPeriods = 0;
    int tomorrowReminderCount = 0;
    List<StudentModel> children = [];
    String? parentName;
    List<TeacherClassSummary> teacherClasses = [];

    if (event.role == UserRole.teacher) {
      currentTeacher = await _teacherRepo.fetchCurrentTeacher();
      teacherClasses = await _teacherRepo.fetchClassSummaries(currentTeacher, _todayName());
      todayPeriods = teacherClasses.fold(0, (sum, c) => sum + c.todayPeriods);
    } else if (event.role == UserRole.parent) {
      parentName = (await _studentRepo.fetchParent('p001'))?.name;
      children = await _studentRepo.fetchChildrenForParent('p001');
      if (children.isNotEmpty) currentStudent = children.first;
    } else {
      currentStudent = await _studentRepo.fetchCurrentStudent();
    }

    if (currentStudent != null) {
      classTeacher = await _studentRepo.fetchClassTeacher(
        currentStudent.classGrade,
        currentStudent.section,
      );
      subjectTeachers = await _studentRepo.fetchSubjectTeachers(
        currentStudent.classGrade,
        currentStudent.section,
      );
      final timetable = await _timetableRepo.fetchTimetable(
        currentStudent.classGrade,
        currentStudent.section,
      );
      todayPeriods = _timetableRepo.periodsCountForDay(timetable, _todayName());
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowName = _dayName(tomorrow);
      final tomorrowIsWeekend = tomorrow.weekday == DateTime.sunday;
      tomorrowPeriods = tomorrowIsWeekend
          ? 0
          : _timetableRepo.periodsCountForDay(timetable, tomorrowName);
      if (!tomorrowIsWeekend) {
        final reminders = await _reminderRepo.fetchRemindersForDay(tomorrowName);
        tomorrowReminderCount = reminders.length;
      }
    }

    final announcements = await _announcementRepo.fetchAnnouncements();

    emit(HomeLoaded(
      role: event.role,
      // TODO: Replace with a DashboardRepository.fetchStats() call once the
      // backend exposes aggregate statistics (total students, attendance %, etc.).
      stats: DummyData.dashboardStats,
      announcements: announcements,
      currentStudent: currentStudent,
      classTeacher: classTeacher,
      subjectTeachers: subjectTeachers,
      todayPeriods: todayPeriods,
      tomorrowPeriods: tomorrowPeriods,
      tomorrowReminderCount: tomorrowReminderCount,
      children: children,
      parentName: parentName,
      currentTeacher: currentTeacher,
      teacherClasses: teacherClasses,
    ));
  }

  Future<void> _onSelectChild(
    HomeSelectChild event,
    Emitter<HomeState> emit,
  ) async {
    final current = state;
    if (current is! HomeLoaded) return;
    final child = event.child;

    // Optimistic switch — show the new child immediately while data reloads
    emit(current.copyWithSelectedChild(
      child: child,
      classTeacher: null,
      subjectTeachers: const [],
      todayPeriods: 0,
    ));

    final classTeacher = await _studentRepo.fetchClassTeacher(
      child.classGrade, child.section);
    final subjectTeachers = await _studentRepo.fetchSubjectTeachers(
      child.classGrade, child.section);
    final timetable = await _timetableRepo.fetchTimetable(
      child.classGrade, child.section);
    final todayPeriods =
        _timetableRepo.periodsCountForDay(timetable, _todayName());
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowName = _dayName(tomorrow);
    final tomorrowIsWeekend = tomorrow.weekday == DateTime.sunday;
    final tomorrowPeriods = tomorrowIsWeekend
        ? 0
        : _timetableRepo.periodsCountForDay(timetable, tomorrowName);
    int tomorrowReminderCount = 0;
    if (!tomorrowIsWeekend) {
      final reminders = await _reminderRepo.fetchRemindersForDay(tomorrowName);
      tomorrowReminderCount = reminders.length;
    }

    final s = state;
    if (s is HomeLoaded && s.currentStudent?.id == child.id) {
      emit(s.copyWithSelectedChild(
        child: child,
        classTeacher: classTeacher,
        subjectTeachers: subjectTeachers,
        todayPeriods: todayPeriods,
        tomorrowPeriods: tomorrowPeriods,
        tomorrowReminderCount: tomorrowReminderCount,
      ));
    }
  }

  void _onMarkRead(HomeMarkAnnouncementRead event, Emitter<HomeState> emit) {
    final current = state;
    if (current is HomeLoaded) {
      emit(current.copyWithRead(event.announcementId));
    }
  }

  String _todayName() => _dayName(DateTime.now());

  String _dayName(DateTime date) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    return days[date.weekday - 1];
  }
}
