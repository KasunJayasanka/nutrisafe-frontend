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
    final day = DateTime.parse(yyyymmdd);

    final goalsF  = _svc.getGoalsByDate(yyyymmdd);
    final brkdF   = _svc.getNutrientBreakdownByDate(yyyymmdd);
    final recentF = _svc.getRecentMealItems(limit: recentLimit);
    final warnF   = _svc.getMealWarningsByDay(day);           // ← added

    // IMPORTANT: include warnF here
    final res = await Future.wait([goalsF, brkdF, recentF, warnF]);

    final goals = GoalsByDateResponse.fromJson(res[0].data);
    final breakdown = NutrientBreakdownResponse.fromJson(res[1].data);
    final recent = (res[2].data['items'] as List)
        .map((e) => RecentMealItem.fromJson(e))
        .toList();

    // warnings payload: { "meals": [...] }
    List<Map<String, String>> alerts = const [];
    try {
      final warnRes = res[3];
      final mealsJson = (warnRes.data['meals'] as List?) ?? const [];
      final mealWarnings = mealsJson.map((e) => MealWarningsDto.fromJson(e)).toList();
      alerts = [
        for (final m in mealWarnings)
          for (final it in m.warningsByItem)
            {
              'type': it.safe ? 'info' : 'warning',
              'message': '${m.type}: ${it.foodLabel} — ${it.warnings}',
              'time': m.ateAt.toIso8601String(),
            }
      ];
    } catch (_) {
      alerts = const []; // fail-closed
    }


    return DashboardData(
      goals: goals,
      breakdown: breakdown,
      recentItems: recent,
      alerts: alerts,
    );
  }

}
