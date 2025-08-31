// lib/features/meal_logging/provider/meal_provider.dart

import 'package:flutter/cupertino.dart';
import '../data/nutrition_preview.dart';
import '../repository/meal_repository.dart';
import '../data/food_model.dart';
import '../data/meal_model.dart';
import '../data/meal_request.dart';
import 'package:frontend_v2/core/services/api_service.dart';
import '../service/meal_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class MealProvider extends ChangeNotifier {
  final MealRepository _repo;
  MealProvider(ApiService api)
      : _repo = MealRepository(MealService(api));

  bool isLoading = false;
  List<Food> searchResults = [];
  List<Food> recognitionResults = [];
  List<Meal> todayMeals = [];

  Meal? editingMeal;
  bool   editingLoading = false;

  Future<void> searchFoods(String q) async {
    searchResults = await _repo.searchFoods(q);
    notifyListeners();
  }

  Future<void> recognizeFoods(String img) async {
    recognitionResults = await _repo.recognizeFoods(img);
    // feed into manual search results
    searchResults = recognitionResults;
    notifyListeners();
  }

  Future<void> logMeal(MealRequest req) async {
    isLoading = true;
    notifyListeners();
    await _repo.logMeal(req);
    await fetchTodayMeals();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMealById(int id) async {
    editingLoading = true;
    notifyListeners();
    try {
      editingMeal = await _repo.getMealById(id);
    } finally {
      editingLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMeal(int id, MealRequest req) async {
    isLoading = true;
    notifyListeners();
    await _repo.updateMeal(id, req);
    await fetchTodayMeals();
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteMeal(int id) async {
    isLoading = true;
    notifyListeners();
    await _repo.deleteMeal(id);
    await fetchTodayMeals();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTodayMeals() async {
    final all = await _repo.getMeals();
    final now = DateTime.now();
    todayMeals = all.where((m) {
      final d = m.ateAt.toLocal();
      return d.year == now.year && d.month == now.month && d.day == now.day;
    }).toList();
    notifyListeners();
  }

  Future<NutritionPreview> previewNutrition(
      String foodId,
      String measureUri,
      double quantity,
      ) {
    return _repo.analyzePreview(foodId, measureUri, quantity);
  }
}

/// Provider bind
final mealProvider = ChangeNotifierProvider((ref) {
  final api = ref.read(apiProvider);
  final prov = MealProvider(api);
  prov.fetchTodayMeals();
  return prov;
});
