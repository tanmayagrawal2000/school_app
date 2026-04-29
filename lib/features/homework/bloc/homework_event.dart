import 'package:equatable/equatable.dart';

abstract class HomeworkEvent extends Equatable {
  const HomeworkEvent();
  @override
  List<Object?> get props => [];
}

class HomeworkFetch extends HomeworkEvent {
  final String classGrade;
  final String section;
  const HomeworkFetch({required this.classGrade, required this.section});
  @override
  List<Object?> get props => [classGrade, section];
}

class HomeworkFilterChanged extends HomeworkEvent {
  final String filter; // 'All', 'Pending', 'Submitted'
  const HomeworkFilterChanged(this.filter);
  @override
  List<Object?> get props => [filter];
}
