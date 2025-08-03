// lib/features/auth/service/auth_service.dart

import 'package:dio/dio.dart';
import 'package:frontend_v2/core/services/secure_storage_service.dart';

class AuthService {
  final Dio _dio;
  final SecureStorageService _storage;

  AuthService({required String baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl)),
        _storage = SecureStorageService();

  /// Returns true on successful login (and writes token), false otherwise.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Store token if present
        if (data.containsKey('token')) {
          await _storage.write(key: 'token', value: data['token']);
        }

        return data;
      }

      return {'error': 'Unexpected response from server'};
    } catch (e) {
      return {'error': 'Login failed: ${e.toString()}'};
    }
  }




  Future<Response> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    return _dio.post('/auth/register', data: {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
    });
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

  Future<void> clearToken() {
    // uses the same SecureStorageService key you wrote to in login()
    return _storage.delete(key: 'token');
  }

  Future<Map<String, dynamic>?> verifyMFA(String code) async {
    final email = await _storage.read(key: 'mfa_email');
    if (email == null) return null;

    try {
      print('📨 Calling /auth/verify-mfa with email: $email and code: $code');

      final resp = await _dio.post('/auth/verify-mfa', data: {
        'email': email,
        'code': code,
      });

      print('✅ Raw response: $resp');
      print('✅ Response data: ${resp.data}');


      if (resp.statusCode == 200 && resp.data != null) {
        final data = resp.data;

        final token = data['token'] as String?;
        final onboarded = data['onboarded'] as bool? ?? false;

        print('📩 Sending verifyMFA request...');
        print('✅ Response: ${resp.data}');
        print('🔐 Token: $token');


        if (token != null) {
          // ✅ FIX: write correct key
          await _storage.write(key: 'token', value: token);
          await _storage.write(key: 'onboarded', value: onboarded.toString());

          return {
            'token': token,
            'onboarded': onboarded,
          };
        }
      }
    } catch (e) {
      print('🔴 verifyMFA error: $e');
    }

    return null;
  }


}
