import 'package:equatable/equatable.dart';
import '../../../data/models/class_stats_model.dart';

abstract class ResultsState extends Equatable {
  const ResultsState();
  @override
  List<Object?> get props => [];
}

class ResultsInitial extends ResultsState {}

class ResultsLoading extends ResultsState {}

class ResultsLoaded extends ResultsState {
  final ClassStats classStats;
  const ResultsLoaded(this.classStats);
  @override
  List<Object?> get props => [classStats];
}

class ResultsError extends ResultsState {
  final String message;
  const ResultsError(this.message);
  @override
  List<Object?> get props => [message];
}
