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

  Future<String> login(String email, String password) async {
    final Response response = await apiService.post(
      '/auth/login',
      {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = response.data;

      if (data['token'] != null) {
        // Normal login success
        final token = data['token'] as String;
        await storageService.write(key: 'auth_token', value: token);
        return 'success';
      } else if (data['message'] == 'MFA code sent to email') {
        // MFA required
        return 'mfa_required';
      } else {
        return 'error';
      }
    } else {
      return 'error';
    }
  }


  Future<bool> register(String firstName,String lastName, String email, String password) async {
    final Response response = await apiService.post(
      '/auth/register',
      {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
      },
    );


    return (response.statusCode == 200 || response.statusCode == 201);
  }

  Future<Map<String, dynamic>?> verifyMFA({
    required String email,
    required String code,
  }) async {
    final response = await apiService.post(
      '/auth/verify-mfa',
      {'email': email, 'code': code},
    );

    if (response.statusCode == 200 && response.data != null) {
      return Map<String, dynamic>.from(response.data);
    }

    return null;
  }

}
