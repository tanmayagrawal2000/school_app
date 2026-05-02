import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/cache/app_cache.dart';
import '../../../data/repositories/homework_repository.dart';
import 'homework_event.dart';
import 'homework_state.dart';

class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  final HomeworkRepository _homeworkRepository;

  HomeworkBloc(this._homeworkRepository) : super(HomeworkInitial()) {
    on<HomeworkFetch>(_onFetch);
    on<HomeworkRefresh>(_onRefresh);
    on<HomeworkFilterChanged>(_onFilterChanged);
  }

  Future<void> _onFetch(
    HomeworkFetch event,
    Emitter<HomeworkState> emit,
  ) async {
    emit(HomeworkLoading());
    await _doFetch(event.classGrade, event.section, event.studentId, emit,
        filter: event.initialFilter);
  }

  Future<void> _onRefresh(
    HomeworkRefresh event,
    Emitter<HomeworkState> emit,
  ) async {
    AppCache.clear();
    final current = state;
    final filter = current is HomeworkLoaded ? current.filter : 'All';
    await _doFetch(event.classGrade, event.section, event.studentId, emit,
        filter: filter);
    event.completer?.complete();
  }

  Future<void> _doFetch(
    String classGrade,
    String section,
    String studentId,
    Emitter<HomeworkState> emit, {
    String filter = 'All',
  }) async {
    try {
      final items = await _homeworkRepository.fetchHomework(
          classGrade, section, studentId);
      emit(HomeworkLoaded(allItems: items, filter: filter));
    } catch (_) {
      emit(const HomeworkError('Failed to load homework.'));
    }
  }

  void _onFilterChanged(
    HomeworkFilterChanged event,
    Emitter<HomeworkState> emit,
  ) {
    final current = state;
    if (current is HomeworkLoaded) {
      emit(current.copyWith(filter: event.filter));
    }
  }
}
