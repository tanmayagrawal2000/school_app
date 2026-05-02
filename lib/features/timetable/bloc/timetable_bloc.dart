import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/cache/app_cache.dart';
import '../../../data/repositories/timetable_repository.dart';
import 'timetable_event.dart';
import 'timetable_state.dart';

class TimetableBloc extends Bloc<TimetableEvent, TimetableState> {
  final TimetableRepository _repository;

  TimetableBloc(this._repository) : super(TimetableInitial()) {
    on<TimetableFetch>(_onFetch);
    on<TimetableRefresh>(_onRefresh);
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
    emit(TimetableLoaded(
      timetable: timetable,
      selectedDay: _todayName(),
      classGrade: event.classGrade,
      section: event.section,
    ));
  }

  Future<void> _onRefresh(
    TimetableRefresh event,
    Emitter<TimetableState> emit,
  ) async {
    final current = state;
    if (current is! TimetableLoaded) { event.completer?.complete(); return; }
    AppCache.clear();
    final timetable = await _repository.fetchTimetable(
      current.classGrade,
      current.section,
    );
    emit(TimetableLoaded(
      timetable: timetable,
      selectedDay: current.selectedDay,
      classGrade: current.classGrade,
      section: current.section,
    ));
    event.completer?.complete();
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
    return idx < 6 ? days[idx] : days[0];
  }
}
