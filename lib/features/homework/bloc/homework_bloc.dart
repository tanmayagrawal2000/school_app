import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/homework_repository.dart';
import 'homework_event.dart';
import 'homework_state.dart';

class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  final HomeworkRepository _homeworkRepository;

  HomeworkBloc(this._homeworkRepository) : super(HomeworkInitial()) {
    on<HomeworkFetch>(_onFetch);
    on<HomeworkFilterChanged>(_onFilterChanged);
  }

  Future<void> _onFetch(HomeworkFetch event, Emitter<HomeworkState> emit) async {
    emit(HomeworkLoading());
    try {
      final items = await _homeworkRepository.fetchHomework(
          event.classGrade, event.section);
      emit(HomeworkLoaded(allItems: items));
    } catch (_) {
      emit(const HomeworkError('Failed to load homework.'));
    }
  }

  void _onFilterChanged(
      HomeworkFilterChanged event, Emitter<HomeworkState> emit) {
    final current = state;
    if (current is HomeworkLoaded) {
      emit(current.copyWith(filter: event.filter));
    }
  }
}
