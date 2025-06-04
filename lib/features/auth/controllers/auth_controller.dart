// File: lib/features/auth/controllers/auth_controller.dart

import 'package:frontend_v2/features/auth/data/auth_service.dart';
import 'package:dio/dio.dart';

class AuthController {
  final AuthService _service;

  AuthController({ required AuthService service }) : _service = service;

  /// Attempts to log in. Returns true on HTTP 200 + non‐empty token, false otherwise.
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final Response response = await _service.login(
        email: email,
        password: password,
      );


      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>?;
        if (data == null) {
          return false;
        }
        final token = data['token'] as String?;
        if (token == null || token.isEmpty) {
          return false;
        }

        // TODO: Persist `token` somewhere (e.g. FlutterSecureStorage)
        // Example:
        // await secureStorage.write(key: 'auth_token', value: token);

        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  /// Attempts to register. Returns true on HTTP 200/201, false otherwise.
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final Response response = await _service.register(
        fullName: fullName,
        email: email,
        password: password,
      );


      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }
}
