import 'dart:async';

import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../../shared/services/local_storage_service.dart';

/// Attaches Bearer tokens and refreshes once on HTTP 401.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    Dio? refreshDio,
    String? Function()? tokenProvider,
    String? Function()? refreshTokenProvider,
  })  : tokenProvider = tokenProvider ?? _readAccess,
        refreshTokenProvider = refreshTokenProvider ?? _readRefresh,
        _refreshDio = refreshDio ??
            Dio(
              BaseOptions(
                baseUrl: AppConfig.apiBaseUrl,
                connectTimeout: AppConfig.networkTimeout,
                receiveTimeout: AppConfig.networkTimeout,
                headers: const {'Accept': 'application/json'},
              ),
            );

  final String? Function() tokenProvider;
  final String? Function() refreshTokenProvider;
  final Dio _refreshDio;

  static Completer<bool>? _refreshLock;

  static String? _readAccess() {
    try {
      return LocalStorageService.accessToken;
    } catch (_) {
      return null;
    }
  }

  static String? _readRefresh() {
    try {
      return LocalStorageService.refreshToken;
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

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final path = err.requestOptions.path;
    final isAuthCall = path.contains('/auth/login') ||
        path.contains('/auth/signup') ||
        path.contains('/auth/otp') ||
        path.contains('/auth/refresh');

    if (status != 401 || isAuthCall || AppConfig.useMockData) {
      handler.next(err);
      return;
    }

    final refreshed = await _refreshSession();
    if (!refreshed) {
      handler.next(err);
      return;
    }

    try {
      final opts = err.requestOptions;
      opts.headers['Authorization'] =
          'Bearer ${LocalStorageService.accessToken}';
      final response = await _refreshDio.fetch<dynamic>(opts);
      handler.resolve(response);
    } catch (_) {
      handler.next(err);
    }
  }

  Future<bool> _refreshSession() async {
    if (_refreshLock != null) {
      return _refreshLock!.future;
    }
    final lock = Completer<bool>();
    _refreshLock = lock;

    try {
      final refresh = refreshTokenProvider();
      if (refresh == null || refresh.isEmpty) {
        lock.complete(false);
        return false;
      }

      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refresh},
      );
      final data = response.data ?? {};
      final access = data['accessToken'] as String?;
      final nextRefresh = data['refreshToken'] as String?;
      if (access == null ||
          access.isEmpty ||
          nextRefresh == null ||
          nextRefresh.isEmpty) {
        lock.complete(false);
        return false;
      }
      await LocalStorageService.updateTokens(
        accessToken: access,
        refreshToken: nextRefresh,
      );
      lock.complete(true);
      return true;
    } catch (_) {
      lock.complete(false);
      return false;
    } finally {
      _refreshLock = null;
    }
  }
}
