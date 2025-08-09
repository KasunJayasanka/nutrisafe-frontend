class DailyProgressItem {
  final int id;
  final DateTime date;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double sodium;
  final double sugar;
  final int hydration;
  final int exercise;

  DailyProgressItem({
    required this.id,
    required this.date,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.sodium,
    required this.sugar,
    required this.hydration,
    required this.exercise,
  });

  factory DailyProgressItem.fromJson(Map<String, dynamic> j) => DailyProgressItem(
    id: j['ID'],
    date: DateTime.parse(j['Date']),
    calories: (j['Calories'] ?? 0).toDouble(),
    protein: (j['Protein'] ?? 0).toDouble(),
    carbs: (j['Carbs'] ?? 0).toDouble(),
    fat: (j['Fat'] ?? 0).toDouble(),
    sodium: (j['Sodium'] ?? 0).toDouble(),
    sugar: (j['Sugar'] ?? 0).toDouble(),
    hydration: j['Hydration'] ?? 0,
    exercise: j['Exercise'] ?? 0,
  );
}
