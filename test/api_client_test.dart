import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/core/network/api_client.dart';
import 'package:kayan/core/network/api_exception.dart';

void main() {
  test('ApiClient getJson returns parsed body', () async {
    final dio = Dio();
    dio.httpClientAdapter = _JsonAdapter({
      '/ping': {'ok': true},
    });

    final client = ApiClient(dio: dio);
    final data = await client.getJson('/ping');
    expect(data['ok'], isTrue);
  });

  test('ApiClient wraps Dio failures as ApiException', () async {
    final dio = Dio();
    dio.httpClientAdapter = _ErrorAdapter();

    final client = ApiClient(dio: dio);
    expect(
      () => client.getJson('/fail'),
      throwsA(isA<ApiException>()),
    );
  });

  test('ApiClient attaches Bearer token via interceptor', () async {
    RequestOptions? captured;
    final dio = Dio();
    dio.httpClientAdapter = _CaptureAdapter((options) {
      captured = options;
      return ResponseBody.fromString(
        '{"ok":true}',
        200,
        headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
      );
    });

    final client = ApiClient(
      dio: dio,
      tokenProvider: () => 'api-test-token',
    );
    final data = await client.getJson('/secure');
    expect(data['ok'], isTrue);
    expect(captured?.headers['Authorization'], 'Bearer api-test-token');
  });
}

class _JsonAdapter implements HttpClientAdapter {
  _JsonAdapter(this._responses);

  final Map<String, Map<String, dynamic>> _responses;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (_responses.containsKey(options.path)) {
      return ResponseBody.fromString(
        '{"ok":true}',
        200,
        headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
      );
    }
    return ResponseBody.fromString('Not found', 404);
  }
}

class _ErrorAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    throw DioException(
      requestOptions: options,
      type: DioExceptionType.connectionError,
      message: 'offline',
    );
  }
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
