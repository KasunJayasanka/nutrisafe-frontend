// File: lib/features/profile/provider/profile_provider.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend_v2/core/providers/api_provider.dart' show apiProvider;
import 'package:frontend_v2/core/providers/secure_storage_provider.dart';
import 'package:frontend_v2/features/profile/service/profile_service.dart';
import 'package:frontend_v2/features/profile/data/profile_repository.dart';
import 'package:frontend_v2/features/profile/data/user_profile.dart';
import 'package:frontend_v2/features/profile/data/bmi_result.dart';



/// 1) Low-level service. Keep as Provider; it doesn't own auth state.
final profileServiceProvider = Provider.autoDispose<ProfileService>((ref) {
  final apiService = ref.watch(apiProvider); // watch so header updates propagate
  return ProfileService(dio: apiService.dio);
});

/// 2) Canonical auth token source (use ONE key everywhere, e.g. 'token').
final authTokenProvider = FutureProvider.autoDispose<String?>((ref) async {
  final storage = ref.watch(secureStorageProvider);
  return storage.read(key: 'token');
});

/// 3) Repository depends on the current token. If token is null, return null.
final profileRepositoryProvider =
Provider.autoDispose<ProfileRepository?>((ref) {
  final tokenAsync = ref.watch(authTokenProvider);
  return tokenAsync.maybeWhen(
    data: (token) {
      if (token == null || token.isEmpty) return null;
      final svc = ref.watch(profileServiceProvider);
      // Ensure the repo (or the service it uses) sets Authorization per token.
      return ProfileRepository(service: svc, bearerToken: token);
    },
    orElse: () => null,
  );
});

/// 4) Fetch profile, but only if repo is available (user logged in).
final profileFutureProvider = FutureProvider.autoDispose<UserProfile>((ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  if (repo == null) throw Exception('Not authenticated.');
  return repo.fetchProfile();
});

/// 5) UpdatePayload unchanged
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
  final String? sex;

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
    this.sex,
  });
}

/// 6) Update uses the same repo (auto-refreshes with token).
final updateProfileProvider =
FutureProvider.autoDispose.family<UserProfile, UpdatePayload>((ref, payload) async {
  final repo = ref.watch(profileRepositoryProvider);
  if (repo == null) throw Exception('Not authenticated.');
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
    sex:                  payload.sex,
  );
});

class BmiArgs {
  final double? heightCm;
  final double? weightKg;
  const BmiArgs({this.heightCm, this.weightKg});
}

final bmiFutureProvider =
FutureProvider.autoDispose.family<BmiResult, BmiArgs>((ref, args) async {
  final repo = ref.watch(profileRepositoryProvider);
  if (repo == null) throw Exception('Not authenticated.');
  return repo.getBmi(
    heightCm: args.heightCm,
    weightKg: args.weightKg,
  );
});

class ChangePasswordPayload {
  final String currentPassword;
  final String newPassword;
  const ChangePasswordPayload({
    required this.currentPassword,
    required this.newPassword,
  });
}

final changePasswordProvider =
FutureProvider.autoDispose.family<void, ChangePasswordPayload>((ref, payload) async {
  final repo = ref.watch(profileRepositoryProvider);
  if (repo == null) throw Exception('Not authenticated.');
  await repo.changePassword(
    currentPassword: payload.currentPassword,
    newPassword: payload.newPassword,
  );
});
