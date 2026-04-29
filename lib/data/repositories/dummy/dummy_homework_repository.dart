import '../../dummy/dummy_data.dart';
import '../../models/homework_model.dart';
import '../homework_repository.dart';

/// In-memory implementation of [HomeworkRepository] backed by [DummyData].
///
/// Replace with [ApiHomeworkRepository] in [app.dart] when the backend is ready.
class DummyHomeworkRepository implements HomeworkRepository {
  @override
  Future<List<HomeworkItem>> fetchHomework(
      String classGrade, String section) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return DummyData.homeworkFor(classGrade, section);
  }
}
