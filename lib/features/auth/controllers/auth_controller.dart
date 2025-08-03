// File: lib/features/auth/controllers/auth_controller.dart

import 'package:frontend_v2/features/auth/data/auth_service.dart';
import 'package:frontend_v2/core/services/secure_storage_service.dart';

class AuthController {
  final AuthService _service;
  final SecureStorageService _storage;

  AuthController({
    required AuthService service,
    required SecureStorageService storage,
  })  : _service = service,
        _storage = storage;

  /// Attempts to log in. Returns true if login succeeded (and token was stored).
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await _service.login(email: email, password: password);
  }


  Future<Map<String, dynamic>?> verifyMFA(String code) {
    return _service.verifyMFA(code);
  }


  /// Attempts to register. Returns true on HTTP 200/201, false otherwise.
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final resp = await _service.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      return resp.statusCode == 200 || resp.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  /// Logs out by clearing the stored token (and any onboarding flag).
  Future<void> logout() async {
    await _service.clearToken();                         // removes access_token
    await _storage.delete(key: 'onboarded');             // optional: clear onboard flag
  }

  /// Retrieves the raw JWT, if stored.
  Future<String?> getToken() {
    return _storage.read(key: 'access_token');
  }
}
