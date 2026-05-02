import 'dart:async';
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
  final String initialFilter;
  const HomeworkFetch({
    required this.classGrade,
    required this.section,
    required this.studentId,
    this.initialFilter = 'All',
  });
  @override
  List<Object?> get props => [classGrade, section, studentId, initialFilter];
}

class HomeworkFilterChanged extends HomeworkEvent {
  final String filter; // 'All', 'Pending', 'Submitted'
  const HomeworkFilterChanged(this.filter);
  @override
  List<Object?> get props => [filter];
}

class HomeworkRefresh extends HomeworkEvent {
  final String classGrade;
  final String section;
  final String studentId;
  final Completer<void>? completer;
  const HomeworkRefresh({
    required this.classGrade,
    required this.section,
    required this.studentId,
    this.completer,
  });
  @override
  List<Object?> get props => [classGrade, section, studentId];
}
