import '../models/badge_model.dart';
import '../models/badge_type_model.dart';

abstract class BadgeRepository {
  /// Returns all badge type templates (the catalogue teachers choose from).
  Future<List<BadgeTypeModel>> fetchBadgeTypes();

  /// Returns all badges awarded to [studentId], newest first.
  Future<List<BadgeModel>> fetchBadges(String studentId);

  /// Creates a new badge awarded by a teacher. Returns the saved badge.
  Future<BadgeModel> awardBadge(BadgeModel badge);

  /// Removes a previously awarded badge by its [badgeId].
  Future<void> revokeBadge(String badgeId);
}
