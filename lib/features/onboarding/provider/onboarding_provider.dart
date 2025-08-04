
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend_v2/core/providers/api_provider.dart';
import '../data/onboarding_model.dart';
import '../data/onboarding_repository.dart';
import '../service/onboarding_service.dart';
import 'package:frontend_v2/core/services/secure_storage_service.dart';

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  final api = ref.watch(apiProvider);
  return OnboardingService(api);
});

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final service = ref.watch(onboardingServiceProvider);
  return OnboardingRepositoryImpl(service);
});

final onboardingNotifierProvider =
StateNotifierProvider<OnboardingNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(onboardingRepositoryProvider);
  return OnboardingNotifier(repo);
});

class OnboardingNotifier extends StateNotifier<AsyncValue<void>> {
  final OnboardingRepository _repo;
  OnboardingNotifier(this._repo) : super(const AsyncData(null));

  Future<void> submit(OnboardingModel data) async {
    state = const AsyncLoading();
    try {
      final ok = await _repo.complete(data);
      if (ok) {
        // just create one on the fly:
        final storage = SecureStorageService();
        await storage.write(key: 'onboarded', value: 'true');
        state = const AsyncData(null);
      } else {
        state = AsyncError('Submission failed', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
