import 'package:equatable/equatable.dart';
import '../../../core/enums/user_role.dart';
import '../../../data/models/announcement_model.dart';
import '../../../data/models/student_model.dart';
import '../../../data/models/teacher_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final UserRole role;
  final Map<String, dynamic> stats;
  final List<AnnouncementModel> announcements;

  // Populated for student / parent roles only
  final StudentModel? currentStudent;
  final TeacherModel? classTeacher;
  final List<TeacherModel> subjectTeachers;
  final int todayPeriods;

  final Set<String> readIds;

  const HomeLoaded({
    required this.role,
    required this.stats,
    required this.announcements,
    this.currentStudent,
    this.classTeacher,
    this.subjectTeachers = const [],
    this.todayPeriods = 0,
    this.readIds = const {},
  });

  bool get isTeacher => role == UserRole.teacher;
  bool isRead(String id) => readIds.contains(id);

  HomeLoaded copyWithRead(String id) => HomeLoaded(
        role: role,
        stats: stats,
        announcements: announcements,
        currentStudent: currentStudent,
        classTeacher: classTeacher,
        subjectTeachers: subjectTeachers,
        todayPeriods: todayPeriods,
        readIds: {...readIds, id},
      );

  @override
  List<Object?> get props => [
        role,
        stats,
        announcements,
        currentStudent,
        classTeacher,
        subjectTeachers,
        todayPeriods,
        readIds,
      ];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}
