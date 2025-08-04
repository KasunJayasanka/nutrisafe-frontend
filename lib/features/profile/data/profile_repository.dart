// File: lib/features/profile/data/profile_repository.dart

import 'package:frontend_v2/features/profile/data/user_profile.dart';
import 'package:frontend_v2/features/profile/service/profile_service.dart';

class ProfileRepository {
  final ProfileService service;
  final String bearerToken;

  ProfileRepository({
    required this.service,
    required this.bearerToken,
  });

  Future<UserProfile> fetchProfile() {
    return service.fetchProfile(bearerToken);
  }

  Future<UserProfile> updateProfile({
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
  }) {
    return service.updateProfile(
      token:                bearerToken,
      firstName:            firstName,
      lastName:             lastName,
      birthday:             birthday,
      height:               height,
      weight:               weight,
      onboarded:            onboarded,
      healthConditions:     healthConditions,
      fitnessGoals:         fitnessGoals,
      mfaEnabled:           mfaEnabled,
      profilePictureBase64: profilePictureBase64,
    );
  }

}
