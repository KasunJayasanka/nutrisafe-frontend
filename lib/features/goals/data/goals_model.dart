class Goals {
  final int id;
  final int userId;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int sodium;
  final int sugar;
  final int hydration; // glasses
  final int exercise;  // minutes

  Goals({
    required this.id,
    required this.userId,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.sodium,
    required this.sugar,
    required this.hydration,
    required this.exercise,
  });

  factory Goals.fromJson(Map<String, dynamic> j) => Goals(
    id: j['ID'],
    userId: j['UserID'],
    calories: j['Calories'],
    protein: j['Protein'],
    carbs: j['Carbs'],
    fat: j['Fat'],
    sodium: j['Sodium'],
    sugar: j['Sugar'],
    hydration: j['Hydration'],
    exercise: j['Exercise'],
  );

  Map<String, dynamic> toPatchJson() => {
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'sodium': sodium,
    'sugar': sugar,
    'hydration': hydration,
    'exercise': exercise,
  };

  Goals copyWith({
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
    int? sodium,
    int? sugar,
    int? hydration,
    int? exercise,
  }) => Goals(
    id: id,
    userId: userId,
    calories: calories ?? this.calories,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fat: fat ?? this.fat,
    sodium: sodium ?? this.sodium,
    sugar: sugar ?? this.sugar,
    hydration: hydration ?? this.hydration,
    exercise: exercise ?? this.exercise,
  );
}

class MetricProgress {
  final double consumed;
  final double goal;
  double get percent => goal == 0 ? 0 : (consumed / goal);

  MetricProgress({required this.consumed, required this.goal});

  factory MetricProgress.fromJson(Map<String, dynamic> j) =>
      MetricProgress(consumed: (j['consumed'] ?? 0).toDouble(), goal: (j['goal'] ?? 0).toDouble());
}

class GoalsProgress {
  final MetricProgress calories;
  final MetricProgress protein;
  final MetricProgress carbs;
  final MetricProgress fat;
  final MetricProgress sodium;
  final MetricProgress sugar;
  final MetricProgress hydration;
  final MetricProgress exercise;

  GoalsProgress({
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
    calories: MetricProgress.fromJson(j['calories']),
    protein:  MetricProgress.fromJson(j['protein']),
    carbs:    MetricProgress.fromJson(j['carbs']),
    fat:      MetricProgress.fromJson(j['fat']),
    sodium:   MetricProgress.fromJson(j['sodium']),
    sugar:    MetricProgress.fromJson(j['sugar']),
    hydration:MetricProgress.fromJson(j['hydration']),
    exercise: MetricProgress.fromJson(j['exercise']),
  );
}
