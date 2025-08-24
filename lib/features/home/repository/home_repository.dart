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

  Future<DashboardData> fetchDashboard({
    required String yyyymmdd,
    int recentLimit = 3,
  }) async {
    final day = DateTime.parse(yyyymmdd);

    // Fire in parallel
    final goalsF  = _svc.getGoalsByDate(yyyymmdd);
    final brkdF   = _svc.getNutrientBreakdownByDate(yyyymmdd);
    final recentF = _svc.getRecentMealItems(limit: recentLimit);
    final warnF   = _svc.getMealWarningsByDay(day);

    final res = await Future.wait([goalsF, brkdF, recentF, warnF]);

    // Small helpers to avoid crashes
    Map<String, dynamic> _asMap(dynamic v) =>
        (v is Map<String, dynamic>) ? v : <String, dynamic>{};
    List _asList(dynamic v) => (v is List) ? v : const [];

    // ----- goals -----
    final goalsJson = _asMap(res[0].data);
    final goals = GoalsByDateResponse.fromJson(goalsJson);

    // ----- breakdown -----
    final breakdownJson = _asMap(res[1].data);
    final breakdown = NutrientBreakdownResponse.fromJson(breakdownJson);

    // ----- recent items -----
    final recentRoot = _asMap(res[2].data);
    final recentItemsJson = _asList(recentRoot['items']);
    final recent = recentItemsJson
        .whereType<Map<String, dynamic>>() // only maps
        .map((e) => RecentMealItem.fromJson(e))
        .toList();

    // ----- warnings → alerts for UI -----
    final warnRoot = _asMap(res[3].data);
    final mealsJson = _asList(warnRoot['meals']);
    final mealWarnings = mealsJson
        .whereType<Map<String, dynamic>>()
        .map((e) => MealWarningsDto.fromJson(e))
        .toList();

    final alerts = <Map<String, String>>[
      for (final m in mealWarnings)
        for (final it in m.warningsByItem)
          {
            'type'   : it.safe ? 'info' : 'warning',
            'message': '${m.type}: ${it.foodLabel} — ${it.warnings}'.toString(),
            'time'   : m.ateAt.toIso8601String(),
          }
    ];

    return DashboardData(
      goals: goals,
      breakdown: breakdown,
      recentItems: recent,
      alerts: alerts,
    );
  }
}

