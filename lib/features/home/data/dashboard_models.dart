import 'dart:convert';

class GoalsByDateResponse {
  final String date;
  final DailyGoals goals;
  final Progress progress;
  GoalsByDateResponse({required this.date, required this.goals, required this.progress});

  factory GoalsByDateResponse.fromJson(Map<String, dynamic> j) => GoalsByDateResponse(
    date: j['date'] as String,
    goals: DailyGoals.fromJson(j['goals']),
    progress: Progress.fromJson(j['progress']),
  );
}

class DailyGoals {
  final double calories, protein, carbs, fat, sodium, sugar, hydration, exercise;
  DailyGoals({
    required this.calories, required this.protein, required this.carbs,
    required this.fat, required this.sodium, required this.sugar,
    required this.hydration, required this.exercise,
  });
  factory DailyGoals.fromJson(Map<String, dynamic> j) => DailyGoals(
    calories: (j['Calories'] as num).toDouble(),
    protein:  (j['Protein']  as num).toDouble(),
    carbs:    (j['Carbs']    as num).toDouble(),
    fat:      (j['Fat']      as num).toDouble(),
    sodium:   (j['Sodium']   as num).toDouble(),
    sugar:    (j['Sugar']    as num).toDouble(),
    hydration:(j['Hydration']as num).toDouble(),
    exercise: (j['Exercise'] as num).toDouble(),
  );
}

class Pct {
  final double consumed, goal, percent;
  Pct({required this.consumed, required this.goal, required this.percent});
  factory Pct.fromJson(Map<String, dynamic> j) => Pct(
    consumed: (j['consumed'] as num).toDouble(),
    goal:     (j['goal']     as num).toDouble(),
    percent:  (j['percent']  as num).toDouble(),
  );
}

class Progress {
  final Pct calories, protein, carbs, fat, sodium, sugar, hydration, exercise;
  Progress({
    required this.calories, required this.protein, required this.carbs,
    required this.fat, required this.sodium, required this.sugar,
    required this.hydration, required this.exercise,
  });
  factory Progress.fromJson(Map<String, dynamic> j) => Progress(
    calories:  Pct.fromJson(j['calories']),
    protein:   Pct.fromJson(j['protein']),
    carbs:     Pct.fromJson(j['carbs']),
    fat:       Pct.fromJson(j['fat']),
    sodium:    Pct.fromJson(j['sodium']),
    sugar:     Pct.fromJson(j['sugar']),
    hydration: Pct.fromJson(j['hydration']),
    exercise:  Pct.fromJson(j['exercise']),
  );
}

/// Nutrient breakdown (macros + micros)
class NutrientStat {
  final double consumed;
  final String unit;
  final double? goal;
  final double? percent;
  NutrientStat({required this.consumed, required this.unit, this.goal, this.percent});

  factory NutrientStat.fromJson(Map<String, dynamic> j) => NutrientStat(
    consumed: (j['consumed'] as num).toDouble(),
    unit: j['unit'] as String,
    goal: (j['goal'] == null) ? null : (j['goal'] as num).toDouble(),
    percent: (j['percent'] == null) ? null : (j['percent'] as num).toDouble(),
  );
}

class NutrientBreakdownResponse {
  final String date;
  final Map<String, NutrientStat> macros; // calories, protein, carbs, fat
  final Map<String, NutrientStat> micros; // sodium, sugar, ...
  NutrientBreakdownResponse({required this.date, required this.macros, required this.micros});

  factory NutrientBreakdownResponse.fromJson(Map<String, dynamic> j) {
    final b = j['breakdown'] as Map<String, dynamic>;
    Map<String, NutrientStat> _map(Map<String, dynamic> m) =>
        m.map((k, v) => MapEntry(k, NutrientStat.fromJson(v)));
    return NutrientBreakdownResponse(
      date: j['date'] as String,
      macros: _map(b['macros']),
      micros: _map(b['micros']),
    );
  }
}

/// Recent meals (flat items)
class RecentMealItem {
  final int id;
  final int mealId;
  final String foodLabel;
  final double calories;
  final bool safe;
  final DateTime ateAt;
  RecentMealItem({
    required this.id, required this.mealId, required this.foodLabel,
    required this.calories, required this.safe, required this.ateAt,
  });
  factory RecentMealItem.fromJson(Map<String, dynamic> j) => RecentMealItem(
    id: j['id'] as int,
    mealId: j['meal_id'] as int,
    foodLabel: j['food_label'] as String,
    calories: (j['calories'] as num).toDouble(),
    safe: j['safe'] as bool,
    ateAt: DateTime.parse(j['ate_at'] as String),
  );
}

/// Full meal (with items) – used if you want the expanded card
class MealItem {
  final int id;
  final String foodLabel;
  final double calories;
  final bool safe;
  MealItem({required this.id, required this.foodLabel, required this.calories, required this.safe});
  factory MealItem.fromJson(Map<String, dynamic> j) => MealItem(
    id: j['ID'] as int,
    foodLabel: j['FoodLabel'] as String,
    calories: (j['Calories'] as num).toDouble(),
    safe: j['Safe'] as bool,
  );
}

class Meal {
  final int id;
  final String type;
  final DateTime ateAt;
  final List<MealItem> items;
  Meal({required this.id, required this.type, required this.ateAt, required this.items});
  factory Meal.fromJson(Map<String, dynamic> j) => Meal(
    id: j['ID'] as int,
    type: j['Type'] as String,
    ateAt: DateTime.parse(j['AteAt'] as String),
    items: (j['Items'] as List).map((e) => MealItem.fromJson(e)).toList(),
  );
}

/// Aggregate used by the provider
class DashboardData {
  final GoalsByDateResponse goals;
  final NutrientBreakdownResponse breakdown;
  final List<RecentMealItem> recentItems;
  final List<Map<String, String>> alerts;

  DashboardData({
    required this.goals,
    required this.breakdown,
    required this.recentItems,
    this.alerts = const <Map<String, String>>[],
  });

  DashboardData copyWith({
    GoalsByDateResponse? goals,
    NutrientBreakdownResponse? breakdown,
    List<RecentMealItem>? recentItems,
    List<Map<String, String>>? alerts,
  }) {
    return DashboardData(
      goals: goals ?? this.goals,
      breakdown: breakdown ?? this.breakdown,
      recentItems: recentItems ?? this.recentItems,
      alerts: alerts ?? this.alerts,
    );
  }
}

class ItemWarningDto {
  final int mealItemId;
  final String foodLabel;
  final bool safe;
  final String warnings;
  final double calories;

  ItemWarningDto({
    required this.mealItemId,
    required this.foodLabel,
    required this.safe,
    required this.warnings,
    required this.calories,
  });

  factory ItemWarningDto.fromJson(Map<String, dynamic> j) => ItemWarningDto(
    mealItemId: j['meal_item_id'] as int,
    foodLabel:  j['food_label'] as String,
    safe:       j['safe'] as bool,
    warnings:   j['warnings'] as String,
    calories:   (j['calories'] as num).toDouble(),
  );
}

class MealWarningsDto {
  final int mealId;
  final String type;
  final DateTime ateAt;
  final bool mealSafe;
  final List<ItemWarningDto> warningsByItem;

  MealWarningsDto({
    required this.mealId,
    required this.type,
    required this.ateAt,
    required this.mealSafe,
    required this.warningsByItem,
  });

  factory MealWarningsDto.fromJson(Map<String, dynamic> j) => MealWarningsDto(
    mealId: j['meal_id'] as int,
    type:   j['type'] as String,
    ateAt:  DateTime.parse(j['ate_at'] as String),
    mealSafe: j['meal_safe'] as bool,
    warningsByItem: (j['warnings_by_item'] as List?)
        ?.map((e) => ItemWarningDto.fromJson(e))
        .toList() ?? <ItemWarningDto>[],
  );
}