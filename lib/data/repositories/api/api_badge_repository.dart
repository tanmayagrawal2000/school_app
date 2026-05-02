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

  /// GET `/badge-types`
  ///
  /// Returns the catalog of all available badge templates.
  /// No request parameters.
  /// Teachers use this list to pick a badge type before awarding it to a student.
  ///
  /// Valid materialType values: `gold` | `blueEnamel` | `bronze` | `darkWood` | `marble` | `copper`
  /// Valid iconName values: `calendarCheck` | `bookOpen` | `wandMagicSparkles` | `chessKing` |
  /// `medal` | `graduationCap` | `crown` | `trophy` | `chartLine` | `gem` | `calculator` |
  /// `atom` | `flask` | `microchip` | `earthAsia` | `penNib` | `star`
  ///
  /// Sample response:
  /// ```json
  /// [
  ///   {
  ///     "id": "bt001",
  ///     "defaultLabel": "Perfect Attendance",
  ///     "defaultDescription": "Awarded for 100% attendance in a term.",
  ///     "defaultBannerText": "ATTENDANCE",
  ///     "materialType": "gold",
  ///     "iconName": "calendarCheck",
  ///     "isPremium": false
  ///   },
  ///   {
  ///     "id": "bt002",
  ///     "defaultLabel": "Academic Excellence",
  ///     "defaultDescription": "Awarded for scoring above 90% overall.",
  ///     "defaultBannerText": "EXCELLENCE",
  ///     "materialType": "blueEnamel",
  ///     "iconName": "graduationCap",
  ///     "isPremium": true
  ///   }
  /// ]
  /// ```
  @override
  Future<List<BadgeTypeModel>> fetchBadgeTypes() async {
    final list = await _client.getList(ApiEndpoints.badgeTypes);
    return list.map(BadgeTypeModel.fromJson).toList();
  }

  /// GET `/students/{studentId}/badges`
  ///
  /// Sample input: `studentId = "s001"`
  ///
  /// Sample response:
  /// ```json
  /// [
  ///   {
  ///     "id": "b001",
  ///     "studentId": "s001",
  ///     "badgeTypeId": "bt001",
  ///     "label": "Perfect Attendance",
  ///     "description": "100% attendance in Term 1.",
  ///     "bannerText": "ATTENDANCE",
  ///     "materialType": "gold",
  ///     "iconName": "calendarCheck",
  ///     "year": 2025,
  ///     "awardedBy": "Mrs. Sunita Verma",
  ///     "awardedAt": "2025-06-30T10:00:00.000Z",
  ///     "isPremium": false
  ///   }
  /// ]
  /// ```
  @override
  Future<List<BadgeModel>> fetchBadges(String studentId) async {
    final list = await _client.getList(
      ApiEndpoints.badgesForStudent(studentId),
    );
    return list.map(BadgeModel.fromJson).toList();
  }

  /// POST `/badges`
  ///
  /// Awards a new badge to a student. Returns the created badge with server-assigned `id`.
  ///
  /// Sample request body:
  /// ```json
  /// {
  ///   "studentId": "s001",
  ///   "badgeTypeId": "bt002",
  ///   "label": "Academic Excellence",
  ///   "description": "Scored 93% overall in Term 1.",
  ///   "bannerText": "EXCELLENCE",
  ///   "materialType": "blueEnamel",
  ///   "iconName": "graduationCap",
  ///   "year": 2025,
  ///   "awardedBy": "Mrs. Sunita Verma",
  ///   "awardedAt": "2025-06-30T10:00:00.000Z",
  ///   "isPremium": true
  /// }
  /// ```
  ///
  /// Sample response (201 Created):
  /// ```json
  /// {
  ///   "id": "b002",
  ///   "studentId": "s001",
  ///   "badgeTypeId": "bt002",
  ///   "label": "Academic Excellence",
  ///   "description": "Scored 93% overall in Term 1.",
  ///   "bannerText": "EXCELLENCE",
  ///   "materialType": "blueEnamel",
  ///   "iconName": "graduationCap",
  ///   "year": 2025,
  ///   "awardedBy": "Mrs. Sunita Verma",
  ///   "awardedAt": "2025-06-30T10:00:00.000Z",
  ///   "isPremium": true
  /// }
  /// ```
  @override
  Future<BadgeModel> awardBadge(BadgeModel badge) async {
    final json = await _client.post(ApiEndpoints.badges, body: badge.toJson());
    return BadgeModel.fromJson(json);
  }

  /// DELETE `/badges/{badgeId}`
  ///
  /// Sample input: `badgeId = "b001"`
  ///
  /// Sample response: `204 No Content` (empty body on success).
  @override
  Future<void> revokeBadge(String badgeId) async {
    await _client.delete(ApiEndpoints.badgeById(badgeId));
  }
}
