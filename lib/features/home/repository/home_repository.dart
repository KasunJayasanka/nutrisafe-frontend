import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_v2/features/home/service/home_service.dart';
import 'package:frontend_v2/features/home/data/dashboard_models.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final svc = ref.read(homeServiceProvider);
  return HomeRepository(svc);
});

class HomeRepository {
  final HomeService _svc;
  HomeRepository(this._svc);

  Future<DashboardData> fetchDashboard({required String yyyymmdd, int recentLimit = 3}) async {
    final goalsF   = _svc.getGoalsByDate(yyyymmdd);
    final brkdF    = _svc.getNutrientBreakdownByDate(yyyymmdd);
    final recentF  = _svc.getRecentMealItems(limit: recentLimit);

    final res = await Future.wait([goalsF, brkdF, recentF]);

    final goals = GoalsByDateResponse.fromJson(res[0].data);
    final breakdown = NutrientBreakdownResponse.fromJson(res[1].data);
    final recent = (res[2].data['items'] as List)
        .map((e) => RecentMealItem.fromJson(e))
        .toList();

    return DashboardData(goals: goals, breakdown: breakdown, recentItems: recent);
  }
}
