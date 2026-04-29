// import '../error/app_exception.dart'; // Uncomment when activating Dio
import 'api_endpoints.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HOW TO ACTIVATE REAL HTTP CALLS
// ─────────────────────────────────────────────────────────────────────────────
// 1. Add to pubspec.yaml:
//      dio: ^5.7.0
//
// 2. Uncomment the Dio imports and implementation below.
//
// 3. In app.dart, change each DummyXRepository to ApiXRepository:
//      RepositoryProvider<StudentRepository>(
//        create: (_) => ApiStudentRepository(ApiClient()),
//      ),
// ─────────────────────────────────────────────────────────────────────────────

// import 'package:dio/dio.dart';

/// HTTP client used by all API repository implementations.
///
/// Centralises the base URL, auth headers, timeouts, and error mapping so
/// individual repositories never touch raw HTTP concerns.
class ApiClient {
  final String baseUrl;

  // final Dio _dio;

  ApiClient({this.baseUrl = ApiEndpoints.baseUrl}) {
    // _dio = Dio(BaseOptions(
    //   baseUrl: baseUrl,
    //   connectTimeout: const Duration(seconds: 30),
    //   receiveTimeout: const Duration(seconds: 30),
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'Accept': 'application/json',
    //   },
    // ));
    // _dio.interceptors.addAll([
    //   _AuthInterceptor(),
    //   LogInterceptor(requestBody: true, responseBody: true),
    // ]);
  }

  // ── Public methods ────────────────────────────────────────────────────

  /// GET [path] with optional [queryParams]. Returns decoded JSON body.
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    // try {
    //   final response = await _dio.get(path, queryParameters: queryParams);
    //   return response.data as Map<String, dynamic>;
    // } on DioException catch (e) {
    //   throw _mapDioError(e);
    // }
    throw UnimplementedError(
        'Implement GET $baseUrl$path — see api_client.dart for instructions.');
  }

  /// GET [path] expecting a JSON array. Returns a list of decoded objects.
  Future<List<Map<String, dynamic>>> getList(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    // try {
    //   final response = await _dio.get(path, queryParameters: queryParams);
    //   return (response.data as List).cast<Map<String, dynamic>>();
    // } on DioException catch (e) {
    //   throw _mapDioError(e);
    // }
    throw UnimplementedError(
        'Implement GET (list) $baseUrl$path — see api_client.dart for instructions.');
  }

  /// POST [path] with [body]. Returns the decoded response body.
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    // try {
    //   final response = await _dio.post(path, data: body);
    //   return response.data as Map<String, dynamic>;
    // } on DioException catch (e) {
    //   throw _mapDioError(e);
    // }
    throw UnimplementedError(
        'Implement POST $baseUrl$path — see api_client.dart for instructions.');
  }

  /// PUT [path] with [body]. Returns the decoded response body.
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    throw UnimplementedError(
        'Implement PUT $baseUrl$path — see api_client.dart for instructions.');
  }

  /// DELETE [path]. Returns the decoded response body.
  Future<Map<String, dynamic>> delete(String path) async {
    throw UnimplementedError(
        'Implement DELETE $baseUrl$path — see api_client.dart for instructions.');
  }

  // ── Error mapping ─────────────────────────────────────────────────────

  // AppException _mapDioError(DioException e) {
  //   switch (e.type) {
  //     case DioExceptionType.connectionTimeout:
  //     case DioExceptionType.sendTimeout:
  //     case DioExceptionType.receiveTimeout:
  //     case DioExceptionType.connectionError:
  //       return const NetworkException();
  //     case DioExceptionType.badResponse:
  //       final code = e.response?.statusCode;
  //       if (code == 401) return const AuthException();
  //       if (code == 404) return const NotFoundException();
  //       return ServerException(
  //         e.response?.data?['message'] as String? ?? 'Server error.',
  //         statusCode: code,
  //       );
  //     default:
  //       return AppException('Unexpected error: ${e.message}');  // won't compile — AppException is sealed
  //   }
  // }
}

// ── Auth interceptor skeleton ─────────────────────────────────────────────────
//
// class _AuthInterceptor extends Interceptor {
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     final token = AuthStorage.read(); // implement your token storage
//     if (token != null) {
//       options.headers['Authorization'] = 'Bearer $token';
//     }
//     handler.next(options);
//   }
//
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     if (err.response?.statusCode == 401) {
//       // TODO: refresh token or navigate to login
//     }
//     handler.next(err);
//   }
// }
