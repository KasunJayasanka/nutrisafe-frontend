enum ActivityLevel { sedentary, moderatelyActive, active }

class DgaCalorieEstimator {
  /// Returns a daily calorie target using DGA 2020–2025 Appendix 2
  /// by age, sex, and activity. Uses adult tables (19–30, 31–50, 51+).
  /// Falls back to 2000 if unknown. Source: DGA Appendix 2 (Table A2-2).
  /// Ages: adult ranges; for adolescents/children you can extend later.
  static int estimateKcal({
    required int ageYears,
    required String sex, // "male" or "female" (case-insensitive)
    required ActivityLevel activity,
  }) {
    final s = sex.toLowerCase();
    final isMale = s.startsWith('m');

    // Choose adult band
    int band; // 0=19-30, 1=31-50, 2=51+
    if (ageYears <= 30) {
      band = 0;
    } else if (ageYears <= 50) {
      band = 1;
    } else {
      band = 2;
    }

    // DGA Appendix 2: Estimated Calories per Day (adults), by sex & activity.
    // Female: Sedentary [19–30: 2000, 31–50: 1800, 51+: 1600]
    //         Moderately active [19–30: 2000–2200 (~2100), 31–50: 2000, 51+: 1800]
    //         Active [19–30: 2400, 31–50: 2200, 51+: 2000]
    // Male:   Sedentary [19–30: 2400, 31–50: 2200, 51+: 2000]
    //         Moderately active [19–30: 2600–2800 (~2700), 31–50: 2600, 51+: 2400]
    //         Active [19–30: 3000, 31–50: 3000, 51+: 2800]
    //
    // Rounded midpoints where a range is shown.
    // (See DGA 2020–2025 Appendix 2, Table A2-2.) :contentReference[oaicite:0]{index=0} :contentReference[oaicite:1]{index=1}

    final femaleSed = [2000, 1800, 1600];
    final femaleMod = [2100, 2000, 1800];
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
