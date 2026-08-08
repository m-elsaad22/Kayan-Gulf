import 'package:dio/dio.dart';

import '../../shared/services/local_storage_service.dart';

/// Attaches `Authorization: Bearer <token>` when a token is available.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({String? Function()? tokenProvider})
      : tokenProvider = tokenProvider ?? _readStoredAccessToken;

  final String? Function() tokenProvider;

  static String? _readStoredAccessToken() {
    try {
      return LocalStorageService.accessToken;
    } catch (_) {
      return null;
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokenProvider();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
