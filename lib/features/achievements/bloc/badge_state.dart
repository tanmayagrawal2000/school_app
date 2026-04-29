import 'package:equatable/equatable.dart';
import '../../../data/models/badge_model.dart';
import '../../../data/models/badge_type_model.dart';

abstract class BadgeState extends Equatable {
  const BadgeState();
  @override
  List<Object?> get props => [];
}

class BadgesInitial extends BadgeState {}

class BadgesLoading extends BadgeState {}

class BadgesLoaded extends BadgeState {
  final List<BadgeTypeModel> badgeTypes;
  final List<BadgeModel> earnedBadges;

  const BadgesLoaded({required this.badgeTypes, required this.earnedBadges});

  /// Returns the awarded [BadgeModel] for [typeId], or null if not yet earned.
  BadgeModel? earnedFor(String typeId) {
    try {
      return earnedBadges.firstWhere((b) => b.badgeTypeId == typeId);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [badgeTypes, earnedBadges];
}

class BadgesError extends BadgeState {
  final String message;
  const BadgesError(this.message);
  @override
  List<Object?> get props => [message];
}
