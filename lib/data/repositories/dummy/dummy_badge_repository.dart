import '../../dummy/dummy_data.dart';
import '../../models/badge_model.dart';
import '../../models/badge_type_model.dart';
import '../badge_repository.dart';

class DummyBadgeRepository implements BadgeRepository {
  // In-memory store supports badges awarded during the session.
  final List<BadgeModel> _store = List.from(DummyData.allBadges);

  @override
  Future<List<BadgeTypeModel>> fetchBadgeTypes() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return DummyData.badgeTypes;
  }

  @override
  Future<List<BadgeModel>> fetchBadges(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _store
        .where((b) => b.studentId == studentId)
        .toList()
      ..sort((a, b) => b.awardedAt.compareTo(a.awardedAt));
  }

  @override
  Future<BadgeModel> awardBadge(BadgeModel badge) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _store.add(badge);
    return badge;
  }

  @override
  Future<void> revokeBadge(String badgeId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _store.removeWhere((b) => b.id == badgeId);
  }
}
