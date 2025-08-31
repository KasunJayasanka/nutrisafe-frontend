// lib/features/analytics/providers/analytics_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/analytics_models.dart';
import '../repository/analytics_repository.dart';
import 'analytics_state.dart';

// ---------- helpers ----------
final _dateFmt = DateFormat('yyyy-MM-dd');

String _firstOfMonth(DateTime now) =>
    _dateFmt.format(DateTime(now.year, now.month, 1));

String _lastOfMonth(DateTime now) =>
    _dateFmt.format(DateTime(now.year, now.month + 1, 0));

DateTime _mondayOf(DateTime d) {
  final wd = d.weekday; // Mon=1..Sun=7
  return DateTime(d.year, d.month, d.day).subtract(Duration(days: wd - 1));
}

// ---------- UI state providers ----------
final selectedOverviewDateProvider =
StateProvider<DateTime>((_) => DateTime.now());

// SINGLE weeklyMode provider using the enum from data/analytics_models.dart
final weeklyModeProvider =
StateProvider<WeeklyMode>((_) => WeeklyMode.chart);

// ---------- Combined Overview loader ----------
final analyticsOverviewProvider =
StateNotifierProvider<AnalyticsOverviewNotifier, OverviewState>((ref) {
  final repo = ref.read(analyticsRepositoryProvider);
  return AnalyticsOverviewNotifier(ref, repo);
});

DateTime _firstDayOfMonth(DateTime d) => DateTime(d.year, d.month, 1);

class AnalyticsOverviewNotifier extends StateNotifier<OverviewState> {
  final Ref ref;
  final AnalyticsRepository repo;

  AnalyticsOverviewNotifier(this.ref, this.repo) : super(const OverviewState());

  Future<void> load() async {
    // Update AFTER first frame in the widget:
    // Screens should call this inside addPostFrameCallback/useEffect.
    state = state.copyWith(loading: true, error: null);

    try {
      final date = ref.read(selectedOverviewDateProvider);
      final from = _firstOfMonth(date);
      final to = _lastOfMonth(date);

      final mode = ref.read(weeklyModeProvider);
      final weekStart = _dateFmt.format(_mondayOf(date));

      final summaryF = repo.fetchSummary(
        from: from,
        to: to,
        includeMissingDays: false,
      );
      final weeklyF = repo.fetchWeekly(
        weekStart: weekStart,
        mode: mode,
      );

      final summary = await summaryF;
      final weekly = await weeklyF;

      state = OverviewState(
        summary: summary,
        weekly: weekly,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> changeDate(DateTime d) async {
    ref.read(selectedOverviewDateProvider.notifier).state = d;
    await load();
  }

  Future<void> changeWeeklyMode(WeeklyMode m) async {
    ref.read(weeklyModeProvider.notifier).state = m;
    await load();
  }

  Future<void> changeMonth(DateTime monthStart) async {
    ref.read(selectedOverviewDateProvider.notifier).state = _firstDayOfMonth(monthStart);
    await load();
  }

  // convenience for prev/next month
  Future<void> prevMonth() => changeMonth(
    DateTime(ref.read(selectedOverviewDateProvider).year,
        ref.read(selectedOverviewDateProvider).month - 1, 1),
  );

  Future<void> nextMonth() => changeMonth(
    DateTime(ref.read(selectedOverviewDateProvider).year,
        ref.read(selectedOverviewDateProvider).month + 1, 1),
  );
}


