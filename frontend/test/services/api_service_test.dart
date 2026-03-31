import 'package:flutter_test/flutter_test.dart';
import 'package:ctrl_shift_date/services/api_service.dart';

void main() {
  group('ApiResponse', () {
    test('success creates successful response', () {
      final response = ApiResponse<String>.success('data');
      expect(response.isSuccess, isTrue);
      expect(response.data, 'data');
      expect(response.error, isNull);
    });

    test('success with null data', () {
      final response = ApiResponse<String>.success(null);
      expect(response.isSuccess, isTrue);
      expect(response.data, isNull);
    });

    test('error creates error response', () {
      final response = ApiResponse<String>.error(
        ApiError(statusCode: 404, message: 'Not found'),
      );
      expect(response.isSuccess, isFalse);
      expect(response.error, isNotNull);
      expect(response.error!.statusCode, 404);
    });

    test('when calls success handler on success', () {
      final response = ApiResponse<String>.success('hello');
      final result = response.when(
        success: (data) => 'got: $data',
        failure: (error) => 'error: ${error.message}',
      );
      expect(result, 'got: hello');
    });

    test('when calls failure handler on error', () {
      final response = ApiResponse<String>.error(
        ApiError(statusCode: 500, message: 'Server error'),
      );
      final result = response.when(
        success: (data) => 'got: $data',
        failure: (error) => 'error: ${error.message}',
      );
      expect(result, 'error: Server error');
    });

    test('map transforms data on success', () {
      final response = ApiResponse<int>.success(42);
      final mapped = response.map((data) => 'number: $data');
      expect(mapped.isSuccess, isTrue);
      expect(mapped.data, 'number: 42');
    });

    test('map propagates error', () {
      final response = ApiResponse<int>.error(
        ApiError(statusCode: 400, message: 'Bad request'),
      );
      final mapped = response.map((data) => 'number: $data');
      expect(mapped.isSuccess, isFalse);
      expect(mapped.error!.statusCode, 400);
    });
  });

  group('ApiError', () {
    test('isNetworkError for statusCode 0', () {
      final error = ApiError(statusCode: 0, message: 'No connection');
      expect(error.isNetworkError, isTrue);
      expect(error.isAuthError, isFalse);
    });

    test('isAuthError for 401', () {
      final error = ApiError(statusCode: 401, message: 'Unauthorized');
      expect(error.isAuthError, isTrue);
    });

    test('isAuthError for 403', () {
      final error = ApiError(statusCode: 403, message: 'Forbidden');
      expect(error.isAuthError, isTrue);
    });

    test('isNotFound for 404', () {
      final error = ApiError(statusCode: 404, message: 'Not found');
      expect(error.isNotFound, isTrue);
    });

    test('isServerError for 500+', () {
      final error = ApiError(statusCode: 500, message: 'Internal error');
      expect(error.isServerError, isTrue);
      expect(ApiError(statusCode: 502, message: 'Bad gateway').isServerError, isTrue);
    });

    test('isValidationError for 400 and 422', () {
      expect(
        ApiError(statusCode: 400, message: 'Bad request').isValidationError,
        isTrue,
      );
      expect(
        ApiError(statusCode: 422, message: 'Unprocessable').isValidationError,
        isTrue,
      );
    });

    test('toString includes status and message', () {
      final error = ApiError(statusCode: 404, message: 'Not found');
      expect(error.toString(), contains('404'));
      expect(error.toString(), contains('Not found'));
    });
  });

  group('PaginatedResponse', () {
    test('hasMore is true when more pages available', () {
      final response = PaginatedResponse<String>(
        items: ['a', 'b'],
        total: 10,
        page: 1,
        pageSize: 2,
      );
      expect(response.hasMore, isTrue);
    });

    test('hasMore is false on last page', () {
      final response = PaginatedResponse<String>(
        items: ['a', 'b'],
        total: 4,
        page: 2,
        pageSize: 2,
      );
      expect(response.hasMore, isFalse);
    });

    test('fromJson parses correctly', () {
      final json = {
        'items': [
          {'name': 'item1'},
          {'name': 'item2'},
        ],
        'total': 5,
        'page': 1,
        'page_size': 2,
      };

      final response = PaginatedResponse<Map<String, dynamic>>.fromJson(
        json,
        (e) => e,
      );

      expect(response.items.length, 2);
      expect(response.total, 5);
      expect(response.page, 1);
      expect(response.pageSize, 2);
      expect(response.hasMore, isTrue);
    });
  });
}
