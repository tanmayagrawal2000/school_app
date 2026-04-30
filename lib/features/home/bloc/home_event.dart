import 'package:equatable/equatable.dart';
import '../../../core/enums/user_role.dart';
import '../../../data/models/student_model.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class HomeFetchDashboard extends HomeEvent {
  final UserRole role;
  const HomeFetchDashboard(this.role);
  @override
  List<Object?> get props => [role];
}

class HomeMarkAnnouncementRead extends HomeEvent {
  final String announcementId;
  const HomeMarkAnnouncementRead(this.announcementId);
  @override
  List<Object?> get props => [announcementId];
}

class HomeSelectChild extends HomeEvent {
  final StudentModel child;
  const HomeSelectChild(this.child);
  @override
  List<Object?> get props => [child];
}
