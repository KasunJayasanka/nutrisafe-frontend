// lib/features/meal_logging/service/meal_service.dart

import 'package:dio/dio.dart';
import 'package:frontend_v2/core/services/api_service.dart';
import 'package:frontend_v2/core/services/secure_storage_service.dart';
import '../data/food_model.dart';
import '../data/meal_model.dart';
import '../data/meal_request.dart';

class MealService {
  final ApiService _api;
  MealService(this._api);

  Future<List<Food>> searchFoods(String query) async {
    final resp = await _api.get(
      '/food/search',
      queryParameters: {'q': query},
    );
    return (resp.data as List)
        .map((j) => Food.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<List<Food>> recognizeFoods(String imageBase64) async {
    final resp = await _api.post(
      '/food/recognize',
      {'image_base64': imageBase64},
    );
    return (resp.data as List)
        .map((j) => Food.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<void> logMeal(MealRequest req) async {
    final token = await SecureStorageService().read(key: 'token');
    await _api.post(
      '/user/meals',
      req.toJson(),
      options: Options(headers: {
        if (token != null && token.isNotEmpty)
          'Authorization': 'Bearer $token',
      }),
    );
  }


  Future<List<Meal>> fetchMeals() async {
    final token = await SecureStorageService().read(key: 'token');
    final resp = await _api.get(
      '/user/meals',
      options: Options(headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      }),
    );
    return (resp.data as List)
        .map((j) => Meal.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateMeal(int id, MealRequest req) async {
    final token = await SecureStorageService().read(key: 'token');
    await _api.patch(
      '/user/meals/$id',
      req.toJson(),
      options: Options(headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      }),
    );
  }

  Future<void> deleteMeal(int id) async {
    final token = await SecureStorageService().read(key: 'token');
    await _api.dio.delete(
      '/user/meals/$id',
      options: Options(headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      }),
    );
  }

  Future<Meal> getMeal(int id) async {
    final token = await SecureStorageService().read(key: 'token');
    final resp = await _api.get(
      '/user/meals/$id',
      options: Options(headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      }),
    );
    // the response body is a single JSON object
    return Meal.fromJson(resp.data as Map<String, dynamic>);
  }
}
