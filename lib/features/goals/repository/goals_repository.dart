import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/goals_response.dart';
import '../data/daily_progress_model.dart';
import '../service/goals_service.dart';

class GoalsRepository {
  final GoalsService _service;
  GoalsRepository(this._service);

  Future<GoalsResponse> fetchGoals() async {
    final res = await _service.getGoals();
    return GoalsResponse.fromJson(res.data as Map<String, dynamic>);
  }

  Future<GoalsResponse> fetchGoalsByDate(String yyyyMmDd) async {
    final res = await _service.getGoalsByDate(yyyyMmDd);
    return GoalsResponse.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> updateGoals(Map<String, dynamic> body) async {
    await _service.patchGoals(body);
  }

  Future<void> updateDailyActivity({int? hydration, int? exercise}) async {
    await _service.postDailyActivity(hydration: hydration, exercise: exercise);
  }

  Future<List<DailyProgressItem>> fetchAllDailyProgress() async {
    final res = await _service.getAllDailyProgress();
    final list = (res.data as List).cast<Map<String, dynamic>>();
    return list.map(DailyProgressItem.fromJson).toList();
  }
}

final goalsRepositoryProvider = Provider<GoalsRepository>((ref) {
  return GoalsRepository(ref.read(goalsServiceProvider));
});
