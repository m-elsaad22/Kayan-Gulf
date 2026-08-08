import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/core/network/api_exception.dart';

void main() {
  group('ApiException.fromDio', () {
    test('maps connection error to network type', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/home'),
        type: DioExceptionType.connectionError,
        message: 'Socket failed',
      );

      final ex = ApiException.fromDio(error);
      expect(ex.type, ApiExceptionType.network);
      expect(ex.message, contains('Socket'));
    });

    test('maps bad response to server type with status code', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/home'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/home'),
          statusCode: 503,
          data: {'message': 'Service unavailable'},
        ),
      );

      final ex = ApiException.fromDio(error);
      expect(ex.type, ApiExceptionType.server);
      expect(ex.statusCode, 503);
      expect(ex.message, 'Service unavailable');
    });
  });
}
