class FoodInfo {
  final String id;
  final String label;
  final String category;

  FoodInfo({required this.id, required this.label, required this.category});

  factory FoodInfo.fromJson(Map<String, dynamic> j) => FoodInfo(
    id: (j['id'] ?? '') as String,
    label: (j['label'] ?? '') as String,
    category: (j['category'] ?? '') as String,
  );
}

class NutritionSummary {
  final double calories, protein, carbs, fat, sodium, sugar;
  NutritionSummary({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.sodium,
    required this.sugar,
  });

  factory NutritionSummary.fromJson(Map<String, dynamic> j) => NutritionSummary(
    calories: _num(j['calories']),
    protein:  _num(j['protein']),
    carbs:    _num(j['carbs']),
    fat:      _num(j['fat']),
    sodium:   _num(j['sodium']),
    sugar:    _num(j['sugar']),
  );
}

class NutritionPreview {
  final FoodInfo food;
  final String measureUri;
  final double quantity;
  final Map<String, double> nutrients; // e.g. ENERC_KCAL, PROCNT, ...
  final NutritionSummary summary;

  NutritionPreview({
    required this.food,
    required this.measureUri,
    required this.quantity,
    required this.nutrients,
    required this.summary,
  });

  factory NutritionPreview.fromJson(Map<String, dynamic> j) {
    final Map<String, dynamic> nutRaw =
    (j['nutrients'] ?? const <String, dynamic>{}) as Map<String, dynamic>;
    final Map<String, double> nut = {
      for (final e in nutRaw.entries) e.key: _num(e.value),
    };
    return NutritionPreview(
      food: FoodInfo.fromJson(j['food'] as Map<String, dynamic>),
      measureUri: (j['measure_uri'] ?? '') as String,
      quantity: _num(j['quantity']),
      nutrients: nut,
      summary: NutritionSummary.fromJson(
          (j['summary'] ?? const <String, dynamic>{}) as Map<String, dynamic>),
    );
  }
}

double _num(dynamic v) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  return 0.0;
}
