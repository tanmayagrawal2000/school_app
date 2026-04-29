import '../../dummy/dummy_data.dart';
import '../../models/announcement_model.dart';
import '../announcement_repository.dart';

/// In-memory implementation of [AnnouncementRepository] backed by [DummyData].
///
/// Replace with [ApiAnnouncementRepository] in [app.dart] when the backend is ready.
class DummyAnnouncementRepository implements AnnouncementRepository {
  @override
  Future<List<AnnouncementModel>> fetchAnnouncements() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = DummyData.announcements;
    // Pinned items first, then by date descending.
    return [...all.where((a) => a.isPinned), ...all.where((a) => !a.isPinned)];
  }
}
