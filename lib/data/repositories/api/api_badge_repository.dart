import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../models/badge_model.dart';
import '../../models/badge_type_model.dart';
import '../badge_repository.dart';

/// Live API implementation of [BadgeRepository].
///
/// To activate, update [app.dart]:
/// ```dart
/// RepositoryProvider<BadgeRepository>(
///   create: (_) => ApiBadgeRepository(ApiClient()),
/// ),
/// ```
class ApiBadgeRepository implements BadgeRepository {
  final ApiClient _client;

  ApiBadgeRepository(this._client);

  @override
  Future<List<BadgeTypeModel>> fetchBadgeTypes() async {
    final list = await _client.getList(ApiEndpoints.badgeTypes);
    return list.map(BadgeTypeModel.fromJson).toList();
  }

  @override
  Future<List<BadgeModel>> fetchBadges(String studentId) async {
    final list = await _client.getList(
      ApiEndpoints.badgesForStudent(studentId),
    );
    return list.map(BadgeModel.fromJson).toList();
  }

  @override
  Future<BadgeModel> awardBadge(BadgeModel badge) async {
    final json = await _client.post(ApiEndpoints.badges, body: badge.toJson());
    return BadgeModel.fromJson(json);
  }

  @override
  Future<void> revokeBadge(String badgeId) async {
    await _client.delete(ApiEndpoints.badgeById(badgeId));
  }
}
