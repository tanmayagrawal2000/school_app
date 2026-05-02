import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../models/announcement_model.dart';
import '../announcement_repository.dart';

/// Live API implementation of [AnnouncementRepository].
///
/// To activate, update [app.dart]:
/// ```dart
/// RepositoryProvider<AnnouncementRepository>(
///   create: (_) => ApiAnnouncementRepository(ApiClient()),
/// ),
/// ```
class ApiAnnouncementRepository implements AnnouncementRepository {
  final ApiClient _client;

  ApiAnnouncementRepository(this._client);

  /// GET `/announcements`
  ///
  /// Returns all school announcements sorted by date descending.
  /// No request parameters.
  ///
  /// Sample response:
  /// ```json
  /// [
  ///   {
  ///     "id": "a001",
  ///     "title": "Half-Yearly Exam Schedule Released",
  ///     "body": "The half-yearly examinations will commence from 15 Oct 2025. Detailed timetable attached.",
  ///     "date": "2025-09-20T08:00:00.000Z",
  ///     "type": "exam",
  ///     "isPinned": true,
  ///     "postedBy": "Principal"
  ///   },
  ///   {
  ///     "id": "a002",
  ///     "title": "Gandhi Jayanti Holiday",
  ///     "body": "School will remain closed on 2 October on account of Gandhi Jayanti.",
  ///     "date": "2025-09-28T08:00:00.000Z",
  ///     "type": "holiday",
  ///     "isPinned": false,
  ///     "postedBy": "Admin Office"
  ///   },
  ///   {
  ///     "id": "a003",
  ///     "title": "Annual Sports Day",
  ///     "body": "Annual Sports Day will be held on 5 Nov 2025. All students must register by 25 Oct.",
  ///     "date": "2025-10-01T08:00:00.000Z",
  ///     "type": "sports",
  ///     "isPinned": false,
  ///     "postedBy": "Sports Dept."
  ///   }
  /// ]
  /// ```
  /// Valid type values: `exam` | `holiday` | `event` | `general` | `fee` | `sports`
  @override
  Future<List<AnnouncementModel>> fetchAnnouncements() async {
    final list = await _client.getList(ApiEndpoints.announcements);
    return list.map(AnnouncementModel.fromJson).toList();
  }
}
