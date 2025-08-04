// lib/features/meal_logging/data/meal_model.dart

class MealItem {
  final int id;
  final String foodId;
  final String foodLabel;
  double quantity;
  final String measureUri;
  final double calories, protein, carbs, fat, sodium, sugar;
  final bool safe;
  final String warnings;

  MealItem({
    required this.id,
    required this.foodId,
    required this.foodLabel,
    required this.quantity,
    required this.measureUri,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.sodium,
    required this.sugar,
    required this.safe,
    required this.warnings,
  });

  factory MealItem.fromJson(Map<String, dynamic> json) => MealItem(
    id: json['ID'] as int,
    foodId: json['FoodID'] as String,
    foodLabel: json['FoodLabel'] as String,
    quantity: (json['Quantity'] as num).toDouble(),
    measureUri: json['MeasureURI'] as String,
    calories: (json['Calories'] as num).toDouble(),
    protein: (json['Protein'] as num).toDouble(),
    carbs: (json['Carbs'] as num).toDouble(),
    fat: (json['Fat'] as num).toDouble(),
    sodium: (json['Sodium'] as num).toDouble(),
    sugar: (json['Sugar'] as num).toDouble(),
    safe: json['Safe'] as bool,
    warnings: json['Warnings'] as String,
  );
}

class Meal {
  final int id;
  final String type;
  final DateTime ateAt;
  final List<MealItem> items;

  Meal({
    required this.id,
    required this.type,
    required this.ateAt,
    required this.items,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    id: json['ID'] as int,
    type: json['Type'] as String,
    ateAt: DateTime.parse(json['AteAt'] as String),
    items: (json['Items'] as List<dynamic>)
        .map((i) => MealItem.fromJson(i as Map<String, dynamic>))
        .toList(),
  );
}
