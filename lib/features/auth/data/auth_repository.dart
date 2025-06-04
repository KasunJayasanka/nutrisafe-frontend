import 'package:frontend_v2/core/services/secure_storage_service.dart';
import 'package:frontend_v2/core/services/api_service.dart';
import 'package:dio/dio.dart';


class AuthRepository {
  final ApiService apiService;
  final SecureStorageService storageService;

  AuthRepository({
    required this.apiService,
    required this.storageService,
  });

  Future<bool> login(String email, String password) async {
    final Response response = await apiService.post(
      '/auth/login',
      {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      // If your backend returns a token, you might store it now:
      final token = response.data['token'] as String?;
      if (token != null) {
        await storageService.write(key: 'auth_token', value: token);
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String fullName, String email, String password) async {
    final Response response = await apiService.post(
      '/auth/register',
      {
        'full_name': fullName,
        'email': email,
        'password': password,
      },
    );

    return (response.statusCode == 200 || response.statusCode == 201);
  }
}
