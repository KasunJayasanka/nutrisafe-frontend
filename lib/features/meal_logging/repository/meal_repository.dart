// lib/features/meal_logging/repository/meal_repository.dart

import '../data/nutrition_preview.dart';
import '../service/meal_service.dart';
import '../data/food_model.dart';
import '../data/meal_model.dart';
import '../data/meal_request.dart';

class MealRepository {
  final MealService _service;
  MealRepository(this._service);

  Future<List<Food>> searchFoods(String q) => _service.searchFoods(q);
  Future<List<Food>> recognizeFoods(String img) => _service.recognizeFoods(img);
  Future<void> logMeal(MealRequest req) => _service.logMeal(req);
  Future<List<Meal>> getMeals() => _service.fetchMeals();
  Future<void> updateMeal(int id, MealRequest req) => _service.updateMeal(id, req);
  Future<void> deleteMeal(int id) => _service.deleteMeal(id);
  Future<Meal> getMealById(int id) => _service.getMeal(id);

  Future<NutritionPreview> analyzePreview(
      String foodId,
      String measureUri,
      double quantity,
      ) => _service.analyzePreview(foodId, measureUri, quantity);
}
