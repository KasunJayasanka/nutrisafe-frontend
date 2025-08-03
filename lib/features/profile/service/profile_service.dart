// File: lib/features/profile/service/profile_service.dart

import 'package:dio/dio.dart';
import 'package:frontend_v2/features/profile/data/user_profile.dart';
import 'package:frontend_v2/features/profile/data/mfa_response.dart';

class ProfileService {
  final Dio dio;

  ProfileService({ required this.dio });

  Future<UserProfile> fetchProfile(String token) async {
    final response = await dio.get(
      '/user/profile',
      options: Options(
        headers: { 'Authorization': 'Bearer $token' },
      ),
    );
    return UserProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserProfile> updateProfile({
    required String token,
    String? firstName,
    String? lastName,
    DateTime? birthday,
    double? height,
    double? weight,
    bool? onboarded,
    String? healthConditions,
    String? fitnessGoals,
    bool? mfaEnabled,
    String? profilePictureBase64,
  }) async {
    final body = <String, dynamic>{};
    if (firstName        != null) body['first_name']        = firstName;
    if (lastName         != null) body['last_name']         = lastName;
    if (birthday         != null) body['birthday']          = birthday.toIso8601String().split('T').first;
    if (height           != null) body['height']            = height;
    if (weight           != null) body['weight']            = weight;
    if (onboarded        != null) body['onboarded']         = onboarded;
    if (healthConditions != null) body['health_conditions'] = healthConditions;
    if (fitnessGoals     != null) body['fitness_goals']     = fitnessGoals;
    if (mfaEnabled       != null) body['mfa_enabled']       = mfaEnabled;
    if (profilePictureBase64 != null) {
      body['profile_picture'] = profilePictureBase64;
    }

    await dio.patch(
      '/user/profile',
      data: body,
      options: Options(headers: { 'Authorization': 'Bearer $token' }),
    );

    // 2) Immediately GET the updated profile
    final fresh = await dio.get(
        '/user/profile',
        options: Options(headers: { 'Authorization': 'Bearer $token' }),
        );

    return UserProfile.fromJson(fresh.data as Map<String, dynamic>);
  }

  Future<MfaResponse> updateMfa({
    required String token,
    required bool enable,
  }) async {
    final response = await dio.patch(
      '/user/mfa',
      data: {'enable': enable},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return MfaResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
