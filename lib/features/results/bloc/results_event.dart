import 'dart:async';
import 'package:equatable/equatable.dart';

abstract class ResultsEvent extends Equatable {
  const ResultsEvent();
  @override
  List<Object?> get props => [];
}

class ResultsFetch extends ResultsEvent {
  final String classGrade;
  final String section;
  const ResultsFetch({required this.classGrade, required this.section});
  @override
  List<Object?> get props => [classGrade, section];
}

class ResultsRefresh extends ResultsEvent {
  final Completer<void>? completer;
  const ResultsRefresh({this.completer});
}
