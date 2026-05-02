import '../../dummy/dummy_data.dart';
import '../../models/class_reminder_model.dart';
import '../reminder_repository.dart';

/// In-memory implementation of [ReminderRepository] backed by [DummyData].
///
/// Replace with [ApiReminderRepository] in [app.dart] when the backend is ready.
class DummyReminderRepository implements ReminderRepository {
  @override
  Future<List<ClassReminderModel>> fetchRemindersForDay(String dayName) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return DummyData.remindersForDay(dayName);
  }
}
