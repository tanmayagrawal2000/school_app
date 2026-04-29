import 'package:equatable/equatable.dart';
import '../../../data/models/timetable_model.dart';

abstract class TimetableState extends Equatable {
  const TimetableState();
  @override
  List<Object?> get props => [];
}

class TimetableInitial extends TimetableState {}

class TimetableLoading extends TimetableState {}

class TimetableLoaded extends TimetableState {
  final Map<String, List<TimetablePeriod>> timetable;
  final String selectedDay;
  final String classGrade;
  final String section;

  const TimetableLoaded({
    required this.timetable,
    required this.selectedDay,
    required this.classGrade,
    required this.section,
  });

  List<TimetablePeriod> get periodsForSelectedDay =>
      timetable[selectedDay] ?? [];

  TimetableLoaded copyWith({String? selectedDay}) {
    return TimetableLoaded(
      timetable: timetable,
      selectedDay: selectedDay ?? this.selectedDay,
      classGrade: classGrade,
      section: section,
    );
  }

  @override
  List<Object?> get props => [timetable, selectedDay, classGrade, section];
}

class TimetableError extends TimetableState {
  final String message;
  const TimetableError(this.message);
  @override
  List<Object?> get props => [message];
}
