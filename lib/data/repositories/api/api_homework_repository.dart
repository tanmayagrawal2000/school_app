import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../models/homework_model.dart';
import '../homework_repository.dart';

/// Live API implementation of [HomeworkRepository].
///
/// To activate, update [app.dart]:
/// ```dart
/// RepositoryProvider<HomeworkRepository>(
///   create: (_) => ApiHomeworkRepository(ApiClient()),
/// ),
/// ```
class ApiHomeworkRepository implements HomeworkRepository {
  final ApiClient _client;

  ApiHomeworkRepository(this._client);

  @override
  Future<List<HomeworkItem>> fetchHomework(
      String classGrade, String section, String studentId) async {
    final list = await _client.getList(ApiEndpoints.homework,
        queryParams: {
          'classGrade': classGrade,
          'section': section,
          'studentId': studentId,
        });
    return list.map(HomeworkItem.fromJson).toList();
  }

  @override
  Future<void> saveSubmissions(String hwId, Set<String> submittedIds) async {
    await _client.put(
      ApiEndpoints.homeworkSubmissions(hwId),
      body: {'submittedStudentIds': submittedIds.toList()},
    );
  }
}
