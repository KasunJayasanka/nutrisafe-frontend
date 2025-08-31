// lib/features/onboarding/screens/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:frontend_v2/core/theme/app_colors.dart';
import '../data/onboarding_model.dart';
import '../provider/onboarding_provider.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/multi_select_field.dart';
import '../widgets/mfa_toggle.dart';
import '../widgets/number_input_field.dart';
import 'package:frontend_v2/core/enums/sex_option.dart';
import 'package:frontend_v2/core/widgets/sex_selector.dart';


class OnboardingScreen extends HookConsumerWidget {
  /// Called when onboarding completes successfully.
  final VoidCallback onComplete;

  const OnboardingScreen({
    super.key,
    required this.onComplete,
  });

  static const healthOptions = [
    'none','diabetes','hypertension','heart_disease','obesity',
    'thyroid','kidney_disease','food_allergies','digestive_issues',
    'arthritis','other'
  ];

  static const goalOptions = [
    'weight_loss','weight_gain','muscle_building','maintenance',
    'improved_fitness','better_nutrition','disease_management',
    'energy_boost','athletic_performance','healthy_lifestyle'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final birthday       = useState<DateTime?>(null);
    final heightCtrl     = useTextEditingController();
    final weightCtrl     = useTextEditingController();
    final health         = useState<List<String>>(<String>[]);
    final fitness        = useState<List<String>>(<String>[]);
    final otherHealthCtrl= useTextEditingController();
    final mfa            = useState<bool>(true);
    final avatar         = useState<String?>(null);
    final sex = useState<SexOption?>(null);

    final state = ref.watch(onboardingNotifierProvider);
    ref.listen<AsyncValue<void>>(onboardingNotifierProvider, (_, s) {
      s.whenData((_) => onComplete());
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundGradientStart,
              AppColors.backgroundGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.emerald400, AppColors.sky400],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0,0,0,0.10),
                          blurRadius: 10, offset: Offset(0,5),
                        )
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.favorite, size: 32, color: AppColors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  Text(
                    'Complete Your Profile',
                    style: GoogleFonts.poppins(
                      fontSize: 24, fontWeight: FontWeight.w600,
                      foreground: Paint()..shader = const LinearGradient(
                        colors: [AppColors.emerald400,AppColors.sky400],
                      ).createShader(const Rect.fromLTWH(0,0,200,70)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Help us personalize your experience',
                    style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.emerald400,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Card
                  Container(
                    width: 360,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.white80,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0,0,0,0.05),
                          blurRadius: 10, offset: Offset(0,2),
                        )
                      ],
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header
                          Text(
                            'Profile Setup',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Avatar
                          Text(
                            'Profile Picture (Optional)',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AvatarPicker(onPicked: (b64) => avatar.value = b64),
                          const SizedBox(height: 24),
                          // Birthday
                          DatePickerField(
                            label: 'Birthday *',
                            value: birthday.value,
                            prefixIcon: Icons.calendar_today,
                            onChanged: (d) => birthday.value = d,
                          ),
                          const SizedBox(height: 16),
                          // Height & Weight
                          Row(
                            children: [
                              Expanded(
                                child: NumberInputField(
                                  label: 'Height (cm) *',
                                  controller: heightCtrl,
                                  suffix: 'cm',
                                  prefixIcon: Icons.straighten,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: NumberInputField(
                                  label: 'Weight (kg) *',
                                  controller: weightCtrl,
                                  suffix: 'kg',
                                  prefixIcon: Icons.fitness_center,
                                ),
                              ),
                            ],
                          ),
                          // Sex
                          const SizedBox(height: 16),
                          Text(
                            'Sex *',
                            style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black,
                            ),
                          ),
// Radios (compact stack)
                          const SizedBox(height: 16),
                          const Text('Sex *'),
                          SexSelector(
                            value: sex.value,
                            onChanged: (v) => sex.value = v,
                          ),

                          const SizedBox(height: 24),
                          // MFA
                          MfaToggle(
                            enabled: mfa.value,
                            onChanged: (b) => mfa.value = b,
                          ),
                          const SizedBox(height: 24),
                          // Complete Setup
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.buttonGradientStart,
                                  AppColors.buttonGradientEnd,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: state.isLoading
                                  ? null
                                  : () async {
                                if (formKey.currentState!.validate() &&
                                    birthday.value != null) {
                                  final data = OnboardingModel(
                                    birthday:         birthday.value!,
                                    height:           int.parse(heightCtrl.text),
                                    weight:           int.parse(weightCtrl.text),
                                    healthConditions: health.value,
                                    fitnessGoals:     fitness.value,
                                    mfaEnabled:       mfa.value,
                                    profilePicture:   avatar.value,
                                    onboarded:        true,
                                    sex: (sex.value ?? SexOption.ratherNotSay).api,
                                  );
                                  await ref
                                      .read(onboardingNotifierProvider.notifier)
                                      .submit(data);
                                  Navigator.of(context).pushReplacementNamed('/dashboard');
                                }
                              },
                              child: state.isLoading
                                  ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                                  : Text(
                                'Complete Setup',
                                style: GoogleFonts.poppins(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
