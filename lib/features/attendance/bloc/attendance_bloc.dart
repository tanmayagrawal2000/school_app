import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/student_repository.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final StudentRepository _studentRepository;

  AttendanceBloc(this._studentRepository) : super(AttendanceInitial()) {
    on<AttendanceFetch>(_onFetch);
    on<AttendanceMonthChanged>(_onMonthChanged);
  }

  Future<void> _onFetch(
    AttendanceFetch event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    try {
      final records = await _studentRepository.fetchAttendance(event.studentId);
      emit(AttendanceLoaded(
        records: records,
        focusedMonth: DateTime.now(),
      ));
    } catch (e) {
      emit(AttendanceError('Failed to load attendance.'));
    }
  }

  void _onMonthChanged(
    AttendanceMonthChanged event,
    Emitter<AttendanceState> emit,
  ) {
    final current = state;
    if (current is AttendanceLoaded) {
      emit(current.copyWith(focusedMonth: event.focusedDay));
    }
  }
}
