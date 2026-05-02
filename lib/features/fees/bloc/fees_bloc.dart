import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/cache/app_cache.dart';
import '../../../data/repositories/student_repository.dart';
import 'fees_event.dart';
import 'fees_state.dart';

class FeesBloc extends Bloc<FeesEvent, FeesState> {
  final StudentRepository _studentRepository;

  String? _lastStudentId;

  FeesBloc(this._studentRepository) : super(FeesInitial()) {
    on<FeesFetch>(_onFetch);
    on<FeesRefresh>(_onRefresh);
  }

  Future<void> _onFetch(FeesFetch event, Emitter<FeesState> emit) async {
    _lastStudentId = event.studentId;
    emit(FeesLoading());
    await _doFetch(event.studentId, emit);
  }

  Future<void> _onRefresh(FeesRefresh event, Emitter<FeesState> emit) async {
    final id = _lastStudentId;
    if (id == null) { event.completer?.complete(); return; }
    AppCache.clear();
    await _doFetch(id, emit);
    event.completer?.complete();
  }

  Future<void> _doFetch(String studentId, Emitter<FeesState> emit) async {
    try {
      final student = await _studentRepository.fetchStudentById(studentId);
      if (student == null) {
        emit(const FeesError('Student not found.'));
        return;
      }
      final installments =
          await _studentRepository.fetchFeeInstallments(studentId);
      emit(FeesLoaded(student: student, installments: installments));
    } catch (_) {
      emit(const FeesError('Failed to load fee details.'));
    }
  }
}
