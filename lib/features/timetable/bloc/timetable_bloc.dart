import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/timetable_repository.dart';
import 'timetable_event.dart';
import 'timetable_state.dart';

class TimetableBloc extends Bloc<TimetableEvent, TimetableState> {
  final TimetableRepository _repository;

  TimetableBloc(this._repository) : super(TimetableInitial()) {
    on<TimetableFetch>(_onFetch);
    on<TimetableSelectDay>(_onSelectDay);
  }

  Future<void> _onFetch(
    TimetableFetch event,
    Emitter<TimetableState> emit,
  ) async {
    emit(TimetableLoading());
    final timetable = await _repository.fetchTimetable(
      event.classGrade,
      event.section,
    );
    final today = _todayName();
    emit(TimetableLoaded(
      timetable: timetable,
      selectedDay: today,
      classGrade: event.classGrade,
      section: event.section,
    ));
  }

  void _onSelectDay(TimetableSelectDay event, Emitter<TimetableState> emit) {
    if (state is TimetableLoaded) {
      emit((state as TimetableLoaded).copyWith(selectedDay: event.dayName));
    }
  }

  String _todayName() {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    final idx = DateTime.now().weekday - 1;
    // Default to Monday on Sunday (no school)
    return idx < 6 ? days[idx] : days[0];
  }
}
