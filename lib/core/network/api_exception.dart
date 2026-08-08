import 'package:dio/dio.dart';

/// Normalized API failure for repositories and UI layers.
class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.type = ApiExceptionType.unknown,
  });

  final String message;
  final int? statusCode;
  final ApiExceptionType type;

  factory ApiException.fromDio(DioException error) {
    final status = error.response?.statusCode;
    final type = switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        ApiExceptionType.timeout,
      DioExceptionType.connectionError => ApiExceptionType.network,
      DioExceptionType.badResponse => ApiExceptionType.server,
      DioExceptionType.cancel => ApiExceptionType.cancelled,
      _ => ApiExceptionType.unknown,
    };

    final message = error.response?.data is Map
        ? (error.response!.data['message'] as String?) ?? error.message ?? 'Request failed'
        : error.message ?? 'Request failed';

    return ApiException(message: message, statusCode: status, type: type);
  }

  @override
  String toString() => 'ApiException($statusCode, $type, $message)';
}

enum ApiExceptionType {
  network,
  timeout,
  server,
  cancelled,
  unknown,
}
