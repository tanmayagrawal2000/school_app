import 'package:equatable/equatable.dart';

abstract class FeesEvent extends Equatable {
  const FeesEvent();
  @override
  List<Object?> get props => [];
}

class FeesFetch extends FeesEvent {
  final String studentId;
  const FeesFetch(this.studentId);
  @override
  List<Object?> get props => [studentId];
}
