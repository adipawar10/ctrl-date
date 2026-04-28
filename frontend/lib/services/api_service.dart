import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/api_endpoints.dart';
import '../utils/constants.dart';

/// HTTP client for backend API communication
class ApiService {
  ApiService._();

  static final ApiService _instance = ApiService._();
  static ApiService get instance => _instance;

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Shared HTTP client with connection timeout
  final HttpClient _httpClient = HttpClient()
    ..connectionTimeout = const Duration(seconds: 5);

  /// Get the current access token for authenticated requests
  String? get _accessToken => _supabase.auth.currentSession?.accessToken;

  /// Base headers for all requests
  Map<String, String> get _baseHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

  /// Perform a GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final response = await _httpClient.getUrl(uri).then((request) {
        _baseHeaders.forEach(request.headers.add);
        return request.close();
      }).timeout(AppConstants.apiTimeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  /// Perform a POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final request = await _httpClient.postUrl(uri);
      _baseHeaders.forEach(request.headers.add);

      if (body != null) {
        request.write(jsonEncode(body));
      }

      final response = await request.close().timeout(AppConstants.apiTimeout);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  /// Perform a PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final request = await _httpClient.putUrl(uri);
      _baseHeaders.forEach(request.headers.add);

      if (body != null) {
        request.write(jsonEncode(body));
      }

      final response = await request.close().timeout(AppConstants.apiTimeout);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  /// Perform a PATCH request
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final request = await _httpClient.patchUrl(uri);
      _baseHeaders.forEach(request.headers.add);

      if (body != null) {
        request.write(jsonEncode(body));
      }

      final response = await request.close().timeout(AppConstants.apiTimeout);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  /// Perform a DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final request = await _httpClient.deleteUrl(uri);
      _baseHeaders.forEach(request.headers.add);

      final response = await request.close().timeout(AppConstants.apiTimeout);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  /// Build the full URI for an endpoint
  Uri _buildUri(String endpoint, [Map<String, String>? queryParams]) {
    final baseUri = Uri.parse(ApiEndpoints.baseUrl);
    return Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      port: baseUri.port,
      path: '${baseUri.path}$endpoint',
      queryParameters: queryParams,
    );
  }

  /// Handle the HTTP response
  Future<ApiResponse<T>> _handleResponse<T>(
    HttpClientResponse response,
    T Function(dynamic json)? fromJson,
  ) async {
    final responseBody = await response.transform(utf8.decoder).join();
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      if (responseBody.isEmpty) {
        return ApiResponse.success(null);
      }

      final json = jsonDecode(responseBody);

      if (fromJson != null) {
        return ApiResponse.success(fromJson(json));
      }

      return ApiResponse.success(json as T?);
    }

    // Handle error responses
    String errorMessage;
    try {
      final errorJson = jsonDecode(responseBody);
      final detail = errorJson['detail'];
      if (detail is String) {
        errorMessage = detail;
      } else if (detail is List && detail.isNotEmpty) {
        errorMessage = detail.first.toString();
      } else {
        errorMessage =
            errorJson['message'] ?? errorJson['error'] ?? 'Unknown error';
      }
    } catch (_) {
      errorMessage = responseBody.isNotEmpty ? responseBody : 'Request failed';
    }

    return ApiResponse.error(
      ApiError(
        statusCode: statusCode,
        message: errorMessage,
      ),
    );
  }

  /// Handle exceptions and convert to ApiError
  ApiError _handleError(dynamic error) {
    if (error is TimeoutException) {
      return ApiError(
        statusCode: 408,
        message: 'Request timed out. Please check your connection.',
      );
    }

    if (error is SocketException) {
      final msg = error.message;
      final refused =
          msg.contains('refused') || msg.contains('Connection refused');
      if (refused) {
        return ApiError(
          statusCode: 0,
          message: 'Cannot reach the API at ${ApiEndpoints.baseUrl}. '
              'Start the backend on your Mac (e.g. uvicorn on port 8000), then try again.',
        );
      }
      return ApiError(
        statusCode: 0,
        message:
            'Network error ($msg). On a real device, set API_BASE_URL to your Mac\'s LAN IP.',
      );
    }

    if (error is FormatException) {
      return ApiError(
        statusCode: 0,
        message: 'Invalid response format from server.',
      );
    }

    return ApiError(
      statusCode: 0,
      message: error.toString(),
    );
  }
}

/// API response wrapper
class ApiResponse<T> {
  final T? data;
  final ApiError? error;
  final bool isSuccess;

  ApiResponse._({
    this.data,
    this.error,
    required this.isSuccess,
  });

  factory ApiResponse.success(T? data) => ApiResponse._(
        data: data,
        isSuccess: true,
      );

  factory ApiResponse.error(ApiError error) => ApiResponse._(
        error: error,
        isSuccess: false,
      );

  /// Execute a callback based on success or failure
  R when<R>({
    required R Function(T? data) success,
    required R Function(ApiError error) failure,
  }) {
    if (isSuccess) {
      return success(data);
    } else {
      return failure(error!);
    }
  }

  /// Map the data if successful
  ApiResponse<R> map<R>(R Function(T? data) mapper) {
    if (isSuccess) {
      return ApiResponse.success(mapper(data));
    } else {
      return ApiResponse.error(error!);
    }
  }
}

/// API error class
class ApiError {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? details;

  ApiError({
    required this.statusCode,
    required this.message,
    this.details,
  });

  @override
  String toString() => 'ApiError($statusCode): $message';

  /// Check if this is a network error
  bool get isNetworkError => statusCode == 0;

  /// Check if this is an authentication error
  bool get isAuthError => statusCode == 401 || statusCode == 403;

  /// Check if this is a not found error
  bool get isNotFound => statusCode == 404;

  /// Check if this is a server error
  bool get isServerError => statusCode >= 500;

  /// Check if this is a validation error
  bool get isValidationError => statusCode == 400 || statusCode == 422;
}

/// Extension for handling API responses in providers
extension ApiResponseExtension<T> on Future<ApiResponse<T>> {
  /// Convert API response to AsyncValue for Riverpod
  Future<T> getOrThrow() async {
    final response = await this;
    if (response.isSuccess) {
      return response.data as T;
    } else {
      throw response.error!;
    }
  }
}

/// Paginated response wrapper
class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  }) : hasMore = (page * pageSize) < total;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return PaginatedResponse(
      items: (json['items'] as List).map((e) => fromJson(e)).toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
    );
  }
}
