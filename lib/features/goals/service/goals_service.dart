// lib/features/goals/service/goals_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_service.dart';          // same apiProvider you already have
import '../../../core/services/secure_storage_service.dart'; // same service MealService uses

class GoalsService {
  final ApiService _api;
  GoalsService(this._api);

  Future<Response> getGoals() async {
    final token = await SecureStorageService().read(key: 'token');
    return _api.get(
      '/user/goals',
      options: Options(headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      }),
    );
  }

  Future<Response> patchGoals(Map<String, dynamic> body) async {
    final token = await SecureStorageService().read(key: 'token');
    return _api.patch(
      '/user/goals',
      body,
      options: Options(headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      }),
    );
  }

  Future<Response> postDailyActivity({int? hydration, int? exercise}) async {
    final token = await SecureStorageService().read(key: 'token');
    final payload = {
      if (hydration != null) 'hydration': hydration,
      if (exercise != null) 'exercise': exercise,
    };
    return _api.patch(
      '/user/daily-activity',
      payload,
      options: Options(headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      }),
    );
  }

  Future<Response> getAllDailyProgress() async {
    final token = await SecureStorageService().read(key: 'token');
    return _api.get(
      '/user/daily-progress',
      options: Options(headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      }),
    );
  }

  Future<Response> getGoalsByDate(String yyyyMmDd) async {
    final token = await SecureStorageService().read(key: 'token');
    return _api.get(
      '/user/goals-by-date',
      queryParameters: {'date': yyyyMmDd},
      options: Options(headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      }),
    );
  }
}

// Riverpod provider (same style as MealService)
final goalsServiceProvider = Provider<GoalsService>((ref) {
  final api = ref.read(apiProvider);
  return GoalsService(api);
});
