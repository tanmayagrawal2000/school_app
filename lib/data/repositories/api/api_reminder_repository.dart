import '../../../core/cache/app_cache.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../models/class_reminder_model.dart';
import '../reminder_repository.dart';

/// Live API implementation of [ReminderRepository].
///
/// To activate, update [app.dart]:
/// ```dart
/// RepositoryProvider<ReminderRepository>(
///   create: (_) => ApiReminderRepository(ApiClient()),
/// ),
/// ```
class ApiReminderRepository implements ReminderRepository {
  final ApiClient _client;

  ApiReminderRepository(this._client);

  /// GET `/reminders?day=Monday`
  ///
  /// Returns all reminders posted by teachers for the given [dayName].
  ///
  /// Query params: `day` (e.g. `Monday`)
  ///
  /// Sample response:
  /// ```json
  /// [
  ///   {
  ///     "id": "rem001",
  ///     "subject": "Mathematics",
  ///     "message": "Bring graph notebook tomorrow",
  ///     "type": "bring",
  ///     "classGrade": "10",
  ///     "section": "A",
  ///     "dayName": "Monday"
  ///   }
  /// ]
  /// ```
  @override
  Future<List<ClassReminderModel>> fetchRemindersForDay(String dayName) async {
    final key = AppCache.reminders(dayName);
    final cached = AppCache.get<List<ClassReminderModel>>(key, AppCache.shortTtl);
    if (cached != null) return cached;

    final list = await _client.getList(
      ApiEndpoints.reminders,
      queryParams: {'day': dayName},
    );
    final result = list.map(ClassReminderModel.fromJson).toList();
    AppCache.set(key, result);
    return result;
  }
}
