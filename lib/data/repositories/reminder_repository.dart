import '../models/class_reminder_model.dart';

/// Contract for class reminder data operations.
///
/// Swap implementations in [app.dart]:
/// - [DummyReminderRepository] — in-memory data, no network required.
/// - [ApiReminderRepository]   — live backend via [ApiClient].
abstract class ReminderRepository {
  /// Returns all reminders posted for [dayName].
  Future<List<ClassReminderModel>> fetchRemindersForDay(String dayName);
}
