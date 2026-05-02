import 'package:equatable/equatable.dart';

abstract class BadgeEvent extends Equatable {
  const BadgeEvent();
  @override
  List<Object?> get props => [];
}

class BadgesFetch extends BadgeEvent {
  final String studentId;
  const BadgesFetch(this.studentId);
  @override
  List<Object?> get props => [studentId];
}

class BadgeRevoke extends BadgeEvent {
  final String badgeId;
  const BadgeRevoke(this.badgeId);
  @override
  List<Object?> get props => [badgeId];
}
