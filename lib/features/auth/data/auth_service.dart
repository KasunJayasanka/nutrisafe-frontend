
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio;

  AuthService({required String baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<Response> login({
    required String email,
    required String password,
  }) {
    return _dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  /// POST /auth/register
  Future<Response> register({
    required String fullName,
    required String email,
    required String password,
  }) {
    return _dio.post(
      '/auth/register',
      data: {
        'full_name': fullName,
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response> forgotPassword({ required String email }) {
    return _dio.post(
      '/auth/forgot-password',
      data: {'email': email},
    );
  }

  Future<Response> resetPassword({
    required String token,
    required String newPassword,
  }) {
    return _dio.post(
      '/auth/reset-password',
      data: {
        'token': token,
        'new_password': newPassword,
      },
    );
  }
}
