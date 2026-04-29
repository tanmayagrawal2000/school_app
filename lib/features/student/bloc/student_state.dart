import 'package:equatable/equatable.dart';
import '../../../data/models/student_model.dart';
import '../../../data/models/attendance_model.dart';

abstract class StudentState extends Equatable {
  const StudentState();
  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentListLoaded extends StudentState {
  final List<StudentModel> students;
  final List<StudentModel> filtered;
  final String searchQuery;

  const StudentListLoaded({
    required this.students,
    required this.filtered,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [students, filtered, searchQuery];
}

class StudentDetailLoaded extends StudentState {
  final StudentModel student;
  final List<AttendanceRecord> attendance;

  const StudentDetailLoaded({
    required this.student,
    required this.attendance,
  });

  @override
  List<Object?> get props => [student, attendance];
}

class StudentError extends StudentState {
  final String message;
  const StudentError(this.message);
  @override
  List<Object?> get props => [message];
}
