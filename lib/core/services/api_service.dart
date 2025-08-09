// File: lib/core/providers/api_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: dotenv.env['API_BASE_URL'] ?? ''),
  );

  /// Expose the raw Dio instance if any service wants to do manual calls:
  Dio get dio => _dio;

  /// Convenience method for POST requests:
  Future<Response> post(String path, Map<String, dynamic> data, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }


  /// Convenience method for GET requests:
  Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Convenience method for PATCH requests:
  Future<Response> patch(
      String path,
      Map<String, dynamic> data, {
        Options? options,
      }) {
    return _dio.patch(
      path,
      data: data,
      options: options,
    );
  }
}

/// Expose ApiService via Riverpod:
final apiProvider = Provider<ApiService>((ref) {
  return ApiService();
});
