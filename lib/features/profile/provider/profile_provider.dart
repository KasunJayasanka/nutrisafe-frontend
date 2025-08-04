// File: lib/features/profile/provider/profile_provider.dart

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend_v2/core/providers/api_provider.dart' show apiProvider;
import 'package:frontend_v2/core/providers/secure_storage_provider.dart';
import 'package:frontend_v2/features/profile/service/profile_service.dart';
import 'package:frontend_v2/features/profile/data/profile_repository.dart';
import 'package:frontend_v2/features/profile/data/user_profile.dart';

/// 1) Build the low‐level ProfileService from your ApiService.
final profileServiceProvider = Provider<ProfileService>((ref) {
  final apiService = ref.read(apiProvider);
  return ProfileService(dio: apiService.dio);
});

/// 2) Read the JWT out of secure storage.
///    Make sure this key matches what AuthService writes!
final authTokenProvider = FutureProvider<String?>((ref) async {
  final storage = ref.read(secureStorageProvider);
  return await storage.read(key: 'token');
});

/// 3) Wrap ProfileService + token into a ProfileRepository.
final profileRepositoryProvider = FutureProvider<ProfileRepository>((ref) async {
  final token = await ref.watch(authTokenProvider.future);
  if (token == null) throw Exception('No auth token available');

  final svc = ref.read(profileServiceProvider);
  return ProfileRepository(service: svc, bearerToken: token);
});

/// 4) Fetch the user’s profile once on screen load.
final profileFutureProvider = FutureProvider<UserProfile>((ref) async {
  final repo = await ref.watch(profileRepositoryProvider.future);
  return repo.fetchProfile();
});

/// 5) A “delta” object for PATCH’ing only the fields you care about.
class UpdatePayload {
  final String? firstName;
  final String? lastName;
  final DateTime? birthday;
  final double? height;
  final double? weight;
  final bool? onboarded;
  final String? healthConditions;
  final String? fitnessGoals;
  final bool? mfaEnabled;
  final String? profilePictureBase64;

  UpdatePayload({
    this.firstName,
    this.lastName,
    this.birthday,
    this.height,
    this.weight,
    this.onboarded,
    this.healthConditions,
    this.fitnessGoals,
    this.mfaEnabled,
    this.profilePictureBase64,
  });
}

/// 6) Update exactly those fields and return the new UserProfile.

final updateProfileProvider =
FutureProvider.family<UserProfile, UpdatePayload>((ref, payload) async {
  final repo = await ref.read(profileRepositoryProvider.future);
  return repo.updateProfile(
    firstName:            payload.firstName,
    lastName:             payload.lastName,
    birthday:             payload.birthday,
    height:               payload.height,
    weight:               payload.weight,
    onboarded:            payload.onboarded,
    healthConditions:     payload.healthConditions,
    fitnessGoals:         payload.fitnessGoals,
    mfaEnabled:           payload.mfaEnabled,
    profilePictureBase64: payload.profilePictureBase64,
  );
});



