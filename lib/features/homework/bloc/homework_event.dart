import 'package:equatable/equatable.dart';

abstract class HomeworkEvent extends Equatable {
  const HomeworkEvent();
  @override
  List<Object?> get props => [];
}

class HomeworkFetch extends HomeworkEvent {
  final String classGrade;
  final String section;
  final String studentId;
  const HomeworkFetch({
    required this.classGrade,
    required this.section,
    required this.studentId,
  });
  @override
  List<Object?> get props => [classGrade, section, studentId];
}

class HomeworkFilterChanged extends HomeworkEvent {
  final String filter; // 'All', 'Pending', 'Submitted'
  const HomeworkFilterChanged(this.filter);
  @override
  List<Object?> get props => [filter];
}
