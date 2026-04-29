import '../models/homework_model.dart';

/// Contract for homework data operations.
///
/// Swap implementations in [app.dart]:
/// - [DummyHomeworkRepository] — in-memory data, no network required.
/// - [ApiHomeworkRepository]   — live backend via [ApiClient].
abstract class HomeworkRepository {
  /// Returns all homework items assigned to [classGrade]-[section].
  Future<List<HomeworkItem>> fetchHomework(String classGrade, String section);
}
