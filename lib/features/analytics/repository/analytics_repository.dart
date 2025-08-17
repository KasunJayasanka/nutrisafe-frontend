import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/analytics_service.dart';
import '../data/analytics_models.dart';

class AnalyticsRepository {
  final AnalyticsService service;
  AnalyticsRepository(this.service);

  Future<AnalyticsSummary> fetchSummary({
    required String from,
    required String to,
    bool includeMissingDays = false,
  }) =>
      service.getSummary(from: from, to: to, includeMissingDays: includeMissingDays);

  Future<WeeklyOverview> fetchWeekly({
    required String weekStart,
    required WeeklyMode mode,
  }) =>
      service.getWeeklyOverview(weekStart: weekStart, mode: mode);
}

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  final svc = ref.read(analyticsServiceProvider);
  return AnalyticsRepository(svc);
});
