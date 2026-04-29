import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/student_repository.dart';
import 'fees_event.dart';
import 'fees_state.dart';

class FeesBloc extends Bloc<FeesEvent, FeesState> {
  final StudentRepository _studentRepository;

  FeesBloc(this._studentRepository) : super(FeesInitial()) {
    on<FeesFetch>(_onFetch);
  }

  Future<void> _onFetch(FeesFetch event, Emitter<FeesState> emit) async {
    emit(FeesLoading());
    try {
      final student = await _studentRepository.fetchStudentById(event.studentId);
      if (student == null) {
        emit(const FeesError('Student not found.'));
        return;
      }
      final installments =
          await _studentRepository.fetchFeeInstallments(event.studentId);
      emit(FeesLoaded(student: student, installments: installments));
    } catch (_) {
      emit(const FeesError('Failed to load fee details.'));
    }
  }
}
