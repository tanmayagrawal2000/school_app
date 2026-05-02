import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/cache/app_cache.dart';
import '../../../data/repositories/student_repository.dart';
import 'results_event.dart';
import 'results_state.dart';

class ResultsBloc extends Bloc<ResultsEvent, ResultsState> {
  final StudentRepository _studentRepository;

  String? _lastClassGrade;
  String? _lastSection;

  ResultsBloc(this._studentRepository) : super(ResultsInitial()) {
    on<ResultsFetch>(_onFetch);
    on<ResultsRefresh>(_onRefresh);
  }

  Future<void> _onFetch(ResultsFetch event, Emitter<ResultsState> emit) async {
    _lastClassGrade = event.classGrade;
    _lastSection = event.section;
    emit(ResultsLoading());
    await _doFetch(event.classGrade, event.section, emit);
  }

  Future<void> _onRefresh(
      ResultsRefresh event, Emitter<ResultsState> emit) async {
    final grade = _lastClassGrade;
    final section = _lastSection;
    if (grade == null || section == null) { event.completer?.complete(); return; }
    AppCache.clear();
    await _doFetch(grade, section, emit);
    event.completer?.complete();
  }

  Future<void> _doFetch(
    String classGrade,
    String section,
    Emitter<ResultsState> emit,
  ) async {
    try {
      final stats =
          await _studentRepository.fetchClassStats(classGrade, section);
      emit(ResultsLoaded(stats));
    } catch (_) {
      emit(const ResultsError('Failed to load class data.'));
    }
  }
}
