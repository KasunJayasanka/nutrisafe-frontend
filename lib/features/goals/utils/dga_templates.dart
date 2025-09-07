// lib/features/goals/provider/dga_templates.dart

import 'dart:math';

import 'package:frontend_v2/features/profile/data/user_profile.dart';

enum ActivityLevel {
  sedentary,
  moderatelyActive,
  active,
}

/// Map kcal to grams (rounded)
int _kcalToGrams(double kcal, {required int kcalPerGram}) =>
    (kcal / kcalPerGram).round();

/// Compute grams + limits from kcal and desired macro split (all within DGA AMDR).
Map<String, int> _computeFromPercents({
  required int kcal,
  required double pPct, // e.g., 0.20 = 20% kcal
  required double cPct,
  required double fPct,
  int sodiumCapMg = 2300, // DGA sodium cap for age >=14
  int hydrationGlasses = 8,
  int exerciseMin = 30,
}) {
  final pGr = _kcalToGrams(kcal * pPct, kcalPerGram: 4);
  final cGr = _kcalToGrams(kcal * cPct, kcalPerGram: 4);
  final fGr = _kcalToGrams(kcal * fPct, kcalPerGram: 9);

  // Added sugars: DGA <10% kcal; convert to grams (4 kcal/g)
  final sugarMaxGr = _kcalToGrams(kcal * 0.10, kcalPerGram: 4);

  return {
    'calories': kcal,
    'protein': pGr,
    'carbs': cGr,
    'fat': fGr,
    'sodium': sodiumCapMg,
    'sugar': sugarMaxGr,
    'hydration': hydrationGlasses,
    'exercise': exerciseMin,
  };
}

/// DGA calorie estimator using adult bands and activity level.
/// For simplicity: adults only (19+). You can extend later for teens/kids.
class DgaCalorieEstimator {
  static int forAdult({
    required int ageYears,
    required String sex, // "male"/"female"
    required ActivityLevel activity,
  }) {
    final s = sex.toLowerCase();
    final isMale = s.startsWith('m');

    // Adult bands: 19–30, 31–50, 51+
    int band;
    if (ageYears <= 30) {
      band = 0;
    } else if (ageYears <= 50) {
      band = 1;
    } else {
      band = 2;
    }

    // DGA Appendix 2 (Table A2-2) — representative adult kcal targets by sex+activity.
    final femaleSed = [2000, 1800, 1600];
    final femaleMod = [2100, 2000, 1800]; // midpoints where DGA lists a range
    final femaleAct = [2400, 2200, 2000];

    final maleSed = [2400, 2200, 2000];
    final maleMod = [2700, 2600, 2400];
    final maleAct = [3000, 3000, 2800];

    List<int> row;
    if (isMale) {
      row = switch (activity) {
        ActivityLevel.sedentary => maleSed,
        ActivityLevel.moderatelyActive => maleMod,
        ActivityLevel.active => maleAct,
      };
    } else {
      row = switch (activity) {
        ActivityLevel.sedentary => femaleSed,
        ActivityLevel.moderatelyActive => femaleMod,
        ActivityLevel.active => femaleAct,
      };
    }
    return row[band];
  }
}

/// Templates keyed from your UI.
enum DgaTemplateKey {
  maintenanceUSStyle,
  weightLossModerate,   // ~ -15% kcal (or -300 to -500kcal)
  muscleGainModerate,   // ~ +10% kcal
  mediterraneanStyle,   // tilt fat up within AMDR
  vegetarianStyle,      // tilt carbs up within AMDR
  pregnancyTrimester2,  // +340 kcal
  pregnancyTrimester3,  // +452 kcal
  lactationFirst6mo,    // +330 kcal
  lactationSecond6mo,   // +400 kcal
}

/// Build a full template map for the given profile & selection.
/// Defaults: sodium 2300 mg (≥14y); hydration 8 glasses; exercise 30 min/day.
Map<String, int> buildDgaTemplate({
  required UserProfile profile,
  required ActivityLevel activityLevel,
  required DgaTemplateKey key,
}) {
  // Age (years)
  final age = profile.age;
  final sex = (profile.sex.isEmpty) ? 'female' : profile.sex; // safe default if missing
  // Base kcal using DGA adult table:
  final baseKcal = DgaCalorieEstimator.forAdult(
    ageYears: max(19, age), // clamp to adult table
    sex: sex,
    activity: activityLevel,
  );

  int kcal = baseKcal;
  double p = 0.20, c = 0.50, f = 0.30; // default US-Style within AMDR

  switch (key) {
    case DgaTemplateKey.maintenanceUSStyle:
    // keep defaults
      break;

    case DgaTemplateKey.weightLossModerate:
    // Moderate deficit. Use ~-15%. You can clamp to not drop below 1200/1500.
      kcal = (baseKcal * 0.85).round();
      p = 0.25; c = 0.45; f = 0.30; // a touch more protein, still AMDR-compliant
      break;

    case DgaTemplateKey.muscleGainModerate:
      kcal = (baseKcal * 1.10).round();
      p = 0.25; c = 0.50; f = 0.25;
      break;

    case DgaTemplateKey.mediterraneanStyle:
    // Higher-fat (but mostly unsat. in practice) within AMDR:
    // e.g., P20/C45/F35
      p = 0.20; c = 0.45; f = 0.35;
      break;

    case DgaTemplateKey.vegetarianStyle:
    // Higher-carb within AMDR, normal fat, adequate protein
    // e.g., P20/C55/F25
      p = 0.20; c = 0.55; f = 0.25;
      break;

    case DgaTemplateKey.pregnancyTrimester2:
      kcal = baseKcal + 340; // DGA +340 kcal
      // keep macros within AMDR
      p = 0.20; c = 0.50; f = 0.30;
      break;

    case DgaTemplateKey.pregnancyTrimester3:
      kcal = baseKcal + 452; // DGA +452 kcal
      p = 0.20; c = 0.50; f = 0.30;
      break;

    case DgaTemplateKey.lactationFirst6mo:
      kcal = baseKcal + 330;
      p = 0.20; c = 0.50; f = 0.30;
      break;

    case DgaTemplateKey.lactationSecond6mo:
      kcal = baseKcal + 400;
      p = 0.20; c = 0.50; f = 0.30;
      break;
  }

  // Enforce minimum kcal floors to avoid extreme deficits:
  if (sex.toLowerCase().startsWith('m')) {
    kcal = max(kcal, 1500);
  } else {
    kcal = max(kcal, 1200);
  }

  // DGA cap for sodium at ≥14y is 2300 mg. If you later add age <14, set age-specific caps.
  final sodiumCap = 2300;

  return _computeFromPercents(
    kcal: kcal,
    pPct: p,
    cPct: c,
    fPct: f,
    sodiumCapMg: sodiumCap,
    hydrationGlasses: 8,
    exerciseMin: 30,
  );
}
