import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/secure_storage_service.dart';
import '../data/analytics_models.dart';

class AnalyticsService {
  final ApiService api;
  final SecureStorageService storage;

  AnalyticsService({required this.api, required this.storage});

  Future<Map<String, String>> _authHeader() async {
    final token = await storage.read(key: 'token'); // adjust key if different
    return {'Authorization': 'Bearer $token'};
  }

  Future<AnalyticsSummary> getSummary({
    required String from, // yyyy-mm-dd
    required String to,   // yyyy-mm-dd
    bool includeMissingDays = false,
  }) async {
    final headers = await _authHeader();
    final res = await api.get(
      '/user/analytics/summary',
      queryParameters: {
        'from': from,
        'to': to,
        'includeMissingDays': includeMissingDays.toString(),
      },
      options: Options(headers: headers),
    );
    return AnalyticsSummary.fromJson(res.data as Map<String, dynamic>);
  }

  Future<WeeklyOverview> getWeeklyOverview({
    required String weekStart, // yyyy-mm-dd (any day; server snaps to Monday)
    required WeeklyMode mode,
  }) async {
    final headers = await _authHeader();
    final res = await api.get(
      '/user/analytics/weekly-overview',
      queryParameters: {
        'week_start': weekStart,
        'mode': mode == WeeklyMode.chart ? 'chart' : 'detailed',
      },
      options: Options(headers: headers),
    );
    return WeeklyOverview.fromJson(res.data as Map<String, dynamic>);
  }
}

/// Riverpod provider to construct service
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final api = ref.read(apiProvider);
  final storage = SecureStorageService();
  return AnalyticsService(api: api, storage: storage);
});
