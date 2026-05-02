import 'dart:async';
import 'package:equatable/equatable.dart';

abstract class TimetableEvent extends Equatable {
  const TimetableEvent();
  @override
  List<Object?> get props => [];
}

class TimetableFetch extends TimetableEvent {
  final String classGrade;
  final String section;
  const TimetableFetch({required this.classGrade, required this.section});
  @override
  List<Object?> get props => [classGrade, section];
}

class TimetableSelectDay extends TimetableEvent {
  final String dayName;
  const TimetableSelectDay(this.dayName);
  @override
  List<Object?> get props => [dayName];
}

class TimetableRefresh extends TimetableEvent {
  final Completer<void>? completer;
  const TimetableRefresh({this.completer});
}
