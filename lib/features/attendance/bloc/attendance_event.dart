import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();
  @override
  List<Object?> get props => [];
}

class AttendanceFetch extends AttendanceEvent {
  final String studentId;
  const AttendanceFetch(this.studentId);
  @override
  List<Object?> get props => [studentId];
}

class AttendanceMonthChanged extends AttendanceEvent {
  final DateTime focusedDay;
  const AttendanceMonthChanged(this.focusedDay);
  @override
  List<Object?> get props => [focusedDay];
}
