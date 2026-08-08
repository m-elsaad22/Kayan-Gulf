import 'package:dio/dio.dart';

import '../config/app_config.dart';
import 'api_exception.dart';

/// Thin Dio wrapper used by remote repository implementations.
class ApiClient {
  ApiClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppConfig.apiBaseUrl,
                connectTimeout: AppConfig.networkTimeout,
                receiveTimeout: AppConfig.networkTimeout,
                headers: const {'Accept': 'application/json'},
              ),
            );

  final Dio _dio;

  Dio get dio => _dio;

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );
      return response.data ?? {};
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: body);
      return response.data ?? {};
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
