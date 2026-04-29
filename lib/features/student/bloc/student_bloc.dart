import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/student_repository.dart';
import '../../../data/models/student_model.dart';
import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository _repository;

  StudentBloc(this._repository) : super(StudentInitial()) {
    on<StudentFetchAll>(_onFetchAll);
    on<StudentFetchDetail>(_onFetchDetail);
    on<StudentSearch>(_onSearch);
  }

  List<StudentModel> _allStudents = [];

  Future<void> _onFetchAll(
    StudentFetchAll event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    _allStudents = await _repository.fetchStudents();
    emit(StudentListLoaded(students: _allStudents, filtered: _allStudents));
  }

  Future<void> _onFetchDetail(
    StudentFetchDetail event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    final student = await _repository.fetchStudentById(event.studentId);
    if (student == null) {
      emit(const StudentError('Student not found'));
      return;
    }
    final attendance = await _repository.fetchAttendance(student.id);
    emit(StudentDetailLoaded(student: student, attendance: attendance));
  }

  void _onSearch(StudentSearch event, Emitter<StudentState> emit) {
    final q = event.query.toLowerCase();
    final filtered = q.isEmpty
        ? _allStudents
        : _allStudents.where((s) {
            return s.name.toLowerCase().contains(q) ||
                s.classGrade.contains(q) ||
                s.admissionNo.toLowerCase().contains(q) ||
                s.section.toLowerCase().contains(q);
          }).toList();
    emit(StudentListLoaded(
      students: _allStudents,
      filtered: filtered,
      searchQuery: event.query,
    ));
  }
}
