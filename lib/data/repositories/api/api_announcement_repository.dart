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

  @override
  Future<List<AnnouncementModel>> fetchAnnouncements() async {
    final list = await _client.getList(ApiEndpoints.announcements);
    return list.map(AnnouncementModel.fromJson).toList();
  }
}
