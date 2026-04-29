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
  }

  Future<void> _onFetchDashboard(
    HomeFetchDashboard event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    StudentModel? currentStudent;
    TeacherModel? classTeacher;
    List<TeacherModel> subjectTeachers = [];
    int todayPeriods = 0;

    if (event.role != UserRole.teacher) {
      currentStudent = await _studentRepo.fetchCurrentStudent();
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
      todayPeriods =
          _timetableRepo.periodsCountForDay(timetable, _todayName());
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
    ));
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
