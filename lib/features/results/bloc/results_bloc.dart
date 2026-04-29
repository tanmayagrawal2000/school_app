import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/student_repository.dart';
import 'results_event.dart';
import 'results_state.dart';

class ResultsBloc extends Bloc<ResultsEvent, ResultsState> {
  final StudentRepository _studentRepository;

  ResultsBloc(this._studentRepository) : super(ResultsInitial()) {
    on<ResultsFetch>(_onFetch);
  }

  Future<void> _onFetch(ResultsFetch event, Emitter<ResultsState> emit) async {
    emit(ResultsLoading());
    try {
      final stats = await _studentRepository.fetchClassStats(
          event.classGrade, event.section);
      emit(ResultsLoaded(stats));
    } catch (_) {
      emit(const ResultsError('Failed to load class data.'));
    }
  }
}
