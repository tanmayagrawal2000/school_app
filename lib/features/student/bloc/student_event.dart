import 'dart:async';
import 'package:equatable/equatable.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();
  @override
  List<Object?> get props => [];
}

class StudentFetchAll extends StudentEvent {
  const StudentFetchAll();
}

class StudentFetchDetail extends StudentEvent {
  final String studentId;
  const StudentFetchDetail(this.studentId);
  @override
  List<Object?> get props => [studentId];
}

class StudentSearch extends StudentEvent {
  final String query;
  const StudentSearch(this.query);
  @override
  List<Object?> get props => [query];
}

class StudentRefresh extends StudentEvent {
  final Completer<void>? completer;
  const StudentRefresh({this.completer});
}
