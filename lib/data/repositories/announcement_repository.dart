import '../models/announcement_model.dart';

/// Contract for announcement data operations.
///
/// Swap implementations in [app.dart]:
/// - [DummyAnnouncementRepository] — in-memory data, no network required.
/// - [ApiAnnouncementRepository]   — live backend via [ApiClient].
abstract class AnnouncementRepository {
  /// Returns all announcements, sorted with pinned items first.
  Future<List<AnnouncementModel>> fetchAnnouncements();
}
