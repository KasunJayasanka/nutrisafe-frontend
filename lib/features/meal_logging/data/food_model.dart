// lib/features/meal_logging/data/food_model.dart

class Food {
  final String edamamFoodId;
  final String label;
  final String category;

  Food({
    required this.edamamFoodId,
    required this.label,
    required this.category,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    edamamFoodId: json['EdamamFoodID'] as String,
    label: json['Label'] as String,
    category: json['Category'] as String,
  );
}
