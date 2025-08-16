import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_v2/core/services//api_service.dart';
import 'package:frontend_v2/core/services/secure_storage_service.dart';

final homeServiceProvider = Provider<HomeService>((ref) {
  final api = ref.read(apiProvider);
  final storage = SecureStorageService(); // or make a provider if you prefer
  return HomeService(api, storage);
});

class HomeService {
  final ApiService _api;
  final SecureStorageService _storage;
  HomeService(this._api, this._storage);

  Future<Options> _auth() async {
    final token = await _storage.read(key: 'token');
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<Response> getGoalsByDate(String date) async {
    return _api.get('/user/goals-by-date',
        queryParameters: {'date': date},
        options: await _auth());
  }

  Future<Response> getNutrientBreakdownByDate(String date) async {
    return _api.get('/user/nutrient-breakdown-by-date',
        queryParameters: {'date': date},
        options: await _auth());
  }

  Future<Response> getRecentMealItems({int limit = 3}) async {
    return _api.get('/user/meal-items/recent',
        queryParameters: {'limit': limit},
        options: await _auth());
  }

  // If you also need full meals:
  Future<Response> getRecentMeals({int limit = 3}) async {
    return _api.get('/user/meals/recent',
        queryParameters: {'limit': limit},
        options: await _auth());
  }

  Future<Response> getMealWarningsByDay(DateTime day) async {
    // Local start/end of day (device timezone)
    final startLocal = DateTime(day.year, day.month, day.day);
    final endLocal   = startLocal.add(const Duration(days: 1));

    // Convert those instants to UTC, but send as RFC3339 with 'Z'
    String toRfc3339Utc(DateTime dtLocal) =>
        dtLocal.toUtc().toIso8601String().split('.').first + 'Z';

    return _api.get(
      '/user/meals/warnings',
      queryParameters: {
        'from': toRfc3339Utc(startLocal),
        'to':   toRfc3339Utc(endLocal),
      },
      options: await _auth(),
    );
  }

// Optional: single meal
  Future<Response> getMealWarningsById(int mealId) async {
    return _api.get('/user/meals/$mealId/warnings',
        options: await _auth());
  }
}
