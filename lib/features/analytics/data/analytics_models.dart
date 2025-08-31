// lib/features/analytics/data/analytics_models.dart

class NutrAvg {
  final double avgConsumed;
  final double? avgGoal;
  final double? avgPercent; // [0..100]
  final String? unit;

  const NutrAvg({
    required this.avgConsumed,
    this.avgGoal,
    this.avgPercent,
    this.unit,
  });

  factory NutrAvg.fromJson(Map<String, dynamic> j) => NutrAvg(
    avgConsumed: (j['avg_consumed'] ?? 0.0).toDouble(),
    avgGoal: j['avg_goal'] != null ? (j['avg_goal']).toDouble() : null,
    avgPercent: j['avg_percent'] != null ? (j['avg_percent']).toDouble() : null,
    unit: j['unit'] as String?,
  );
}

class AnalyticsSummaryRange {
  final String from; // yyyy-MM-dd
  final String to;   // yyyy-MM-dd
  const AnalyticsSummaryRange({required this.from, required this.to});

  factory AnalyticsSummaryRange.fromJson(Map<String, dynamic> j) =>
      AnalyticsSummaryRange(from: j['from'] as String, to: j['to'] as String);
}

class SafetySummary {
  final double scorePct;
  final int? totalItems;
  final int? unsafeItems;
  final int? safeItems;
  final int? unknownItems;

  const SafetySummary({
    required this.scorePct,
    this.totalItems,
    this.unsafeItems,
    this.safeItems,
    this.unknownItems,
  });

  factory SafetySummary.fromJson(Map<String, dynamic> j) => SafetySummary(
    scorePct: (j['score_pct'] ?? 0).toDouble(),
    totalItems: j['total_items'],
    unsafeItems: j['unsafe_items'],
    safeItems: j['safe_items'],
    unknownItems: j['unknown_items'],
  );
}

class SummaryMetadata {
  final int daysCounted;
  final bool includeMissingDays;

  const SummaryMetadata({
    required this.daysCounted,
    required this.includeMissingDays,
  });

  factory SummaryMetadata.fromJson(Map<String, dynamic> j) => SummaryMetadata(
    daysCounted: j['days_counted'] ?? 0,
    includeMissingDays: j['include_missing_days'] ?? false,
  );
}

class AnalyticsSummary {
  final AnalyticsSummaryRange range;
  final Map<String, NutrAvg> macros; // calories, protein, carbs, fat
  final Map<String, NutrAvg> micros; // sodium, sugar
  final Map<String, NutrAvg> other;  // hydration, exercise
  final SafetySummary safety;
  final SummaryMetadata metadata;

  const AnalyticsSummary({
    required this.range,
    required this.macros,
    required this.micros,
    required this.other,
    required this.safety,
    required this.metadata,
  });

  factory AnalyticsSummary.fromJson(Map<String, dynamic> j) {
    Map<String, NutrAvg> _parseMap(Map<String, dynamic>? m) =>
        (m ?? {}).map((k, v) => MapEntry(k, NutrAvg.fromJson(v)));

    return AnalyticsSummary(
      range: AnalyticsSummaryRange.fromJson(j['range']),
      macros: _parseMap(j['macros']),
      micros: _parseMap(j['micros']),
      other: _parseMap(j['other']),
      safety: SafetySummary.fromJson(j['safety']),
      metadata: SummaryMetadata.fromJson(j['metadata']),
    );
  }
}

/// --- WEEKLY OVERVIEW ---

class WeeklyDayChart {
  final String date; // yyyy-MM-dd
  final Map<String, double> percentages; // calories/protein/... [0..100]

  const WeeklyDayChart({required this.date, required this.percentages});

  factory WeeklyDayChart.fromJson(Map<String, dynamic> j) => WeeklyDayChart(
    date: j['date'] as String,
    percentages: (j['percentages'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, (v ?? 0).toDouble()),
    ),
  );
}

class Metric {
  final double actual;
  final double target;
  final double percent;

  const Metric({required this.actual, required this.target, required this.percent});

  factory Metric.fromJson(Map<String, dynamic> j) => Metric(
    actual: (j['actual'] ?? 0).toDouble(),
    target: (j['target'] ?? 0).toDouble(),
    percent: (j['percent'] ?? 0).toDouble(),
  );
}

class WeeklyDayDetailed {
  final String date;
  final Map<String, Metric> metrics; // calories, protein_g, carbs_g, fat_g, sodium_mg, sugar_g, hydration, exercise_minute

  const WeeklyDayDetailed({required this.date, required this.metrics});

  factory WeeklyDayDetailed.fromJson(Map<String, dynamic> j) => WeeklyDayDetailed(
    date: j['date'] as String,
    metrics: (j['metrics'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, Metric.fromJson(v)),
    ),
  );
}

enum WeeklyMode { chart, detailed }

class WeeklyOverview {
  final String weekStart; // yyyy-MM-dd
  final WeeklyMode mode;
  final List<WeeklyDayChart>? chartDays;
  final List<WeeklyDayDetailed>? detailedDays;

  const WeeklyOverview({
    required this.weekStart,
    required this.mode,
    this.chartDays,
    this.detailedDays,
  });

  factory WeeklyOverview.fromJson(Map<String, dynamic> j) {
    final modeStr = (j['mode'] as String?) ?? 'chart';
    final mode = modeStr == 'detailed' ? WeeklyMode.detailed : WeeklyMode.chart;

    if (mode == WeeklyMode.chart) {
      final days = (j['days'] as List).map((e) => WeeklyDayChart.fromJson(e)).toList();
      return WeeklyOverview(
        weekStart: j['week_start'] as String,
        mode: mode,
        chartDays: days,
      );
    } else {
      final days = (j['days'] as List).map((e) => WeeklyDayDetailed.fromJson(e)).toList();
      return WeeklyOverview(
        weekStart: j['week_start'] as String,
        mode: mode,
        detailedDays: days,
      );
    }
  }
}
