// lib/features/meal_logging/data/meal_request.dart

class MealItemRequest {
  final String foodId;
  final String measureUri;
  final double quantity;

  MealItemRequest({
    required this.foodId,
    required this.measureUri,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'food_id': foodId,
    'measure_uri': measureUri,
    'quantity': quantity,
  };
}

class MealRequest {
  final String type;
  final DateTime ateAt;
  final List<MealItemRequest> items;

  MealRequest({
    required this.type,
    required this.ateAt,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'ate_at': ateAt.toUtc().toIso8601String(),
    'items': items.map((i) => i.toJson()).toList(),
  };
}
