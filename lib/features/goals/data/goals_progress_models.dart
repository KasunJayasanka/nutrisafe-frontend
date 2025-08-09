class ProgressMetric {
  final double consumed;
  final double goal;
  final double percent;
  const ProgressMetric({required this.consumed, required this.goal, required this.percent});
  factory ProgressMetric.fromJson(Map<String, dynamic> j) => ProgressMetric(
    consumed: (j['consumed'] ?? 0).toDouble(),
    goal: (j['goal'] ?? 0).toDouble(),
    percent: (j['percent'] ?? 0).toDouble(),
  );
}

class GoalsProgress {
  final ProgressMetric calories;
  final ProgressMetric protein;
  final ProgressMetric carbs;
  final ProgressMetric fat;
  final ProgressMetric sodium;
  final ProgressMetric sugar;
  final ProgressMetric hydration; // consumed in glasses
  final ProgressMetric exercise;  // consumed in minutes

  const GoalsProgress({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.sodium,
    required this.sugar,
    required this.hydration,
    required this.exercise,
  });

  factory GoalsProgress.fromJson(Map<String, dynamic> j) => GoalsProgress(
    calories: ProgressMetric.fromJson(j['calories']),
    protein: ProgressMetric.fromJson(j['protein']),
    carbs:   ProgressMetric.fromJson(j['carbs']),
    fat:     ProgressMetric.fromJson(j['fat']),
    sodium:  ProgressMetric.fromJson(j['sodium']),
    sugar:   ProgressMetric.fromJson(j['sugar']),
    hydration: ProgressMetric.fromJson(j['hydration']),
    exercise:  ProgressMetric.fromJson(j['exercise']),
  );
}
