// lib/features/onboarding/data/onboarding_model.dart

class OnboardingModel {
  final DateTime      birthday;
  final int           height;
  final int           weight;
  final List<String>  healthConditions;
  final List<String>  fitnessGoals;
  final bool          mfaEnabled;
  final String?       profilePicture;
  final bool          onboarded;  // NEW FIELD

  OnboardingModel({
    required this.birthday,
    required this.height,
    required this.weight,
    List<String>? healthConditions,
    List<String>? fitnessGoals,
    this.mfaEnabled = false,
    this.profilePicture,
    this.onboarded = true,  // default: true
  })  : healthConditions = healthConditions ?? [],
        fitnessGoals     = fitnessGoals     ?? [];

  Map<String, dynamic> toJson() => {
    'birthday':          birthday.toIso8601String().substring(0, 10),
    'height':            height,
    'weight':            weight,
    'health_conditions': healthConditions,
    'fitness_goals':     fitnessGoals,
    'mfa_enabled':       mfaEnabled,
    'profile_picture':   profilePicture,
    'onboarded':         onboarded,  // ADD TO REQUEST
  };
}
