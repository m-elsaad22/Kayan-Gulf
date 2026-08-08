import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/core/network/auth_interceptor.dart';

void main() {
  group('AuthInterceptor', () {
    test('adds Bearer header when token is present', () async {
      RequestOptions? captured;
      final dio = Dio();
      dio.interceptors.add(
        AuthInterceptor(tokenProvider: () => 'secret-token'),
      );
      dio.httpClientAdapter = _CaptureAdapter((options) {
        captured = options;
        return ResponseBody.fromString('{}', 200);
      });

      await dio.get<dynamic>('/protected');

      expect(captured?.headers['Authorization'], 'Bearer secret-token');
    });

    test('skips Authorization header when token is null', () async {
      RequestOptions? captured;
      final dio = Dio();
      dio.interceptors.add(AuthInterceptor(tokenProvider: () => null));
      dio.httpClientAdapter = _CaptureAdapter((options) {
        captured = options;
        return ResponseBody.fromString('{}', 200);
      });

      await dio.get<dynamic>('/public');

      expect(captured?.headers.containsKey('Authorization'), isFalse);
    });

    test('skips Authorization header when token is empty', () async {
      RequestOptions? captured;
      final dio = Dio();
      dio.interceptors.add(AuthInterceptor(tokenProvider: () => ''));
      dio.httpClientAdapter = _CaptureAdapter((options) {
        captured = options;
        return ResponseBody.fromString('{}', 200);
      });

      await dio.get<dynamic>('/public');

      expect(captured?.headers.containsKey('Authorization'), isFalse);
    });
  });
}

class _CaptureAdapter implements HttpClientAdapter {
  _CaptureAdapter(this._onFetch);

  final ResponseBody Function(RequestOptions options) _onFetch;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return _onFetch(options);
  }
}
