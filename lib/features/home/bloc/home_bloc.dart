import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/enums/user_role.dart';
import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/student_model.dart';
import '../../../data/models/teacher_model.dart';
import '../../../data/repositories/announcement_repository.dart';
import '../../../data/repositories/student_repository.dart';
import '../../../data/repositories/timetable_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final StudentRepository _studentRepo;
  final TimetableRepository _timetableRepo;
  final AnnouncementRepository _announcementRepo;

  HomeBloc(this._studentRepo, this._timetableRepo, this._announcementRepo)
      : super(HomeInitial()) {
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
    List<StudentModel> children = [];
    String? parentName;

    if (event.role == UserRole.teacher) {
      currentTeacher = DummyData.currentTeacher;
      final (classGrade, section) = currentTeacher.inchargeClassParts;
      final timetable = await _timetableRepo.fetchTimetable(classGrade, section);
      todayPeriods = _timetableRepo.periodsCountForDay(timetable, _todayName());
    } else if (event.role == UserRole.parent) {
      parentName = DummyData.parentFor('p001')?.name;
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
      children: children,
      parentName: parentName,
      currentTeacher: currentTeacher,
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

    final s = state;
    if (s is HomeLoaded && s.currentStudent?.id == child.id) {
      emit(s.copyWithSelectedChild(
        child: child,
        classTeacher: classTeacher,
        subjectTeachers: subjectTeachers,
        todayPeriods: todayPeriods,
      ));
    }
  }

  void _onMarkRead(HomeMarkAnnouncementRead event, Emitter<HomeState> emit) {
    final current = state;
    if (current is HomeLoaded) {
      emit(current.copyWithRead(event.announcementId));
    }
  }

  String _todayName() {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    return days[DateTime.now().weekday - 1];
  }
}
