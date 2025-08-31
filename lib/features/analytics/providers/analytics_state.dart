// lib/features/analytics/providers/analytics_state.dart
import '../data/analytics_models.dart';

class OverviewState {
  final bool loading;
  final String? error;
  final AnalyticsSummary? summary;
  final WeeklyOverview? weekly;

  const OverviewState({
    this.loading = false,
    this.error,
    this.summary,
    this.weekly,
  });

  OverviewState copyWith({
    bool? loading,
    String? error,
    AnalyticsSummary? summary,
    WeeklyOverview? weekly,
  }) {
    return OverviewState(
      loading: loading ?? this.loading,
      error: error,
      summary: summary ?? this.summary,
      weekly: weekly ?? this.weekly,
    );
  }
}
