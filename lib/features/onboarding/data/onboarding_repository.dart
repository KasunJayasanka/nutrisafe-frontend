import '../data/onboarding_model.dart';
import '../service/onboarding_service.dart';

abstract class OnboardingRepository {
  Future<bool> complete(OnboardingModel data);
}

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingService _service;
  OnboardingRepositoryImpl(this._service);

  @override
  Future<bool> complete(OnboardingModel data) =>
      _service.completeOnboarding(data);
}
