import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/cache/app_cache.dart';
import '../../../data/repositories/student_repository.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final StudentRepository _studentRepository;

  AttendanceBloc(this._studentRepository) : super(AttendanceInitial()) {
    on<AttendanceFetch>(_onFetch);
    on<AttendanceRefresh>(_onRefresh);
    on<AttendanceMonthChanged>(_onMonthChanged);
  }

  Future<void> _onFetch(
    AttendanceFetch event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    await _doFetch(event.studentId, emit);
  }

  Future<void> _onRefresh(
    AttendanceRefresh event,
    Emitter<AttendanceState> emit,
  ) async {
    AppCache.clear();
    await _doFetch(event.studentId, emit);
    event.completer?.complete();
  }

  Future<void> _doFetch(
    String studentId,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      final records = await _studentRepository.fetchAttendance(studentId);
      final current = state;
      emit(AttendanceLoaded(
        records: records,
        focusedMonth: current is AttendanceLoaded
            ? current.focusedMonth
            : DateTime.now(),
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
