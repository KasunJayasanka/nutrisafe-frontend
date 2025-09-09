import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../meal_logging/data/meal_model.dart';
import '../provider/meal_history_provider.dart';
import '../../meal_logging/widgets/meal_card.dart';
import '../../meal_logging/provider/meal_provider.dart';

// If you want your existing GradientAppBar, swap the appBar below.

class MealHistoryScreen extends HookConsumerWidget {
  const MealHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hist = ref.watch(mealHistoryProvider);
    final histCtl = ref.read(mealHistoryProvider.notifier);
    final mealsProv = ref.read(mealProvider); // for MealCard actions

    final mode = hist.mode;
    final isWeekly = mode == HistoryMode.weekly;

    useEffect(() {
      // ensure we have data
      if (!hist.isLoading && (hist.error != null)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load meals: ${hist.error}')),
          );
        });
      }
      return null;
    }, [hist.isLoading, hist.error]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal History'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
      ),
      backgroundColor: Colors.white,
      body: const MealHistoryContent(),
    );
  }
}

class MealHistoryContent extends HookConsumerWidget {
  const MealHistoryContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hist = ref.watch(mealHistoryProvider);
    final histCtl = ref.read(mealHistoryProvider.notifier);
    final mealsProv = ref.read(mealProvider);

    final mode = hist.mode;
    final isWeekly = mode == HistoryMode.weekly;

    useEffect(() {
      if (!hist.isLoading && (hist.error != null)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load meals: ${hist.error}')),
          );
        });
      }
      return null;
    }, [hist.isLoading, hist.error]);

    // ⬇️ This is the same content you currently have in Scaffold->body
    return RefreshIndicator(
      onRefresh: () async => histCtl.loadAll(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SegmentedButton<HistoryMode>(
                  // 👇 add this style block
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    side: MaterialStatePropertyAll(BorderSide(color: AppColors.sky100)),
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      // selected = white “pill”, unselected = soft green
                      return states.contains(MaterialState.selected)
                          ? Colors.white
                          : AppColors.emerald50;
                    }),
                    foregroundColor: MaterialStateProperty.resolveWith((states) {
                      // selected text/icons = emerald, unselected = primary text
                      return states.contains(MaterialState.selected)
                          ? AppColors.emerald600
                          : AppColors.textPrimary;
                    }),
                    padding: const MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  segments: const [
                    ButtonSegment(value: HistoryMode.weekly,  label: Text('Weekly'),  icon: Icon(Icons.view_week)),
                    ButtonSegment(value: HistoryMode.monthly, label: Text('Monthly'), icon: Icon(Icons.calendar_month)),
                  ],
                  selected: {mode},
                  onSelectionChanged: (s) => histCtl.setMode(s.first),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Reload',
                  onPressed: () => histCtl.loadAll(),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (isWeekly) _WeeklyView(mealsProv: mealsProv) else const _MonthlyView(),
          ],
        ),
      ),
    );
  }
}


// ————————————————————————————————————————————————————————————
// Weekly View
// ————————————————————————————————————————————————————————————
class _WeeklyView extends ConsumerWidget {
  final dynamic mealsProv; // MealProvider instance for MealCard
  const _WeeklyView({required this.mealsProv});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hist = ref.watch(mealHistoryProvider);
    final ctl = ref.read(mealHistoryProvider.notifier);

    // Top controls bar (gradient capsule + week nav + inline day row)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Controls (style-aligned with analytics/week_controls.dart)
        _WeekControlsLike(
          weekMonday: hist.weekMonday,
          selectedDate: hist.selectedDate,
          onChangeWeek: ctl.changeWeek,
          onSelectDay: ctl.selectDay,
        ),
        const SizedBox(height: 12),

        // Selected day summary card
        _SelectedDayCard(summary: hist.selectedDaySummary!),

        const SizedBox(height: 12),

        // Daily list for the week
        _WeekDaysList(
          daySummaries: hist.daySummariesInWeek,
          mealsProv: mealsProv,
        ),
      ],
    );
  }
}

/// Smaller “analytics-style” week controls with chevrons and a date picker.
class _WeekControlsLike extends StatelessWidget {
  final DateTime weekMonday;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChangeWeek;
  final ValueChanged<DateTime> onSelectDay;

  const _WeekControlsLike({
    required this.weekMonday,
    required this.selectedDate,
    required this.onChangeWeek,
    required this.onSelectDay,
  });

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (i) => DateTime(weekMonday.year, weekMonday.month, weekMonday.day + i));
    final fmt = DateFormat('EEE');

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [AppColors.backgroundGradientStart, AppColors.backgroundGradientEnd],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: AppColors.emerald600),
                onPressed: () => onChangeWeek(weekMonday.subtract(const Duration(days: 7))),
              ),
              Expanded(
                child: Center(
                  child: _WeekPillLike(
                    label: _rangeLabel(weekMonday),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        initialDate: selectedDate,
                        helpText: 'Pick a week (any date)',
                      );
                      if (picked != null) onChangeWeek(_mondayOf(picked));
                    },
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: AppColors.emerald600),
                onPressed: () => onChangeWeek(weekMonday.add(const Duration(days: 7))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Inline day row (chips)
        Row(
          children: days.map((d) {
            final selected = _sameDay(d, selectedDate);
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: TextButton(
                  onPressed: () => onSelectDay(d),
                  style: TextButton.styleFrom(
                    backgroundColor: selected ? AppColors.sky100 : Colors.white,
                    foregroundColor: selected ? AppColors.emerald600 : AppColors.textPrimary,
                    side: const BorderSide(color: Colors.black26),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(fmt.format(d), style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  static String _rangeLabel(DateTime monday) {
    final start = DateFormat('MMM d').format(monday);
    final end = DateFormat('MMM d').format(monday.add(const Duration(days: 6)));
    return '$start – $end';
  }

  static DateTime _mondayOf(DateTime d) =>
      DateTime(d.year, d.month, d.day).subtract(Duration(days: d.weekday - 1));
  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _WeekPillLike extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _WeekPillLike({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.sky100),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_month, size: 18, color: AppColors.emerald600),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

/// Selected day macro totals (analytics vibe)
class _SelectedDayCard extends StatelessWidget {
  final DaySummary summary;
  const _SelectedDayCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final pretty = DateFormat('y-MM-dd (EEE)').format(summary.day);
    final tiles = [
      _TileSpec(bg: AppColors.sky50,      title: 'Calories', value: _n(summary.totals.calories), accent: const Color(0xFF075985)),
      _TileSpec(bg: AppColors.emerald50,  title: 'Protein (g)', value: _n(summary.totals.protein),  accent: const Color(0xFF065F46)),
      _TileSpec(bg: const Color(0xFFF3E8FF), title: 'Carbs (g)', value: _n(summary.totals.carbs), accent: const Color(0xFF6B21A8)),
      _TileSpec(bg: const Color(0xFFFFF7ED), title: 'Fat (g)', value: _n(summary.totals.fat), accent: const Color(0xFF92400E)),
      _TileSpec(bg: const Color(0xFFEFF6FF), title: 'Sodium (mg)', value: _n(summary.totals.sodium), accent: const Color(0xFF1E40AF)),
      _TileSpec(bg: const Color(0xFFFFF1F2), title: 'Sugar (g)', value: _n(summary.totals.sugar), accent: const Color(0xFFBE123C)),
    ];

    return Card(
      color: AppColors.cardBackground,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.today, color: AppColors.emerald600, size: 20),
            const SizedBox(width: 8),
            Text(pretty, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const Spacer(),
            _chip('Items: ${summary.itemCount}'),
            const SizedBox(width: 8),
            _chip('Safe: ${summary.safeItems}'),
            const SizedBox(width: 8),
            _chip('Unsafe: ${summary.unsafeItems}'),
          ]),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tiles.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisExtent: 72, crossAxisSpacing: 12, mainAxisSpacing: 12,
            ),
            itemBuilder: (_, i) => _MetricTile(spec: tiles[i]),
          ),
        ]),
      ),
    );
  }

  static String _n(double v) => v.toStringAsFixed(0);
  static Widget _chip(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: AppColors.emerald100, borderRadius: BorderRadius.circular(20)),
    child: Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF065F46))),
  );
}

/// Week day list: groups by date and shows meals; reuses MealCard for each meal.

class _WeekDaysList extends ConsumerWidget {
  final List<DaySummary> daySummaries;
  final dynamic mealsProv;

  const _WeekDaysList({
    required this.daySummaries,
    required this.mealsProv,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (daySummaries.isEmpty) {
      return _empty('No meals in this week.');
    }
    return Column(
      children: daySummaries.map((s) => _daySection(context, ref, s)).toList(),
    );
  }

  Widget _daySection(BuildContext ctx, WidgetRef ref, DaySummary s) {
    final dateLabel = DateFormat('y-MM-dd (EEE)').format(s.day);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFFE0F2FE), Color(0xFFECFEFF)],
          begin: Alignment.centerLeft, end: Alignment.centerRight,
        ),
        border: Border.all(color: Color(0xFFBFDBFE)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(dateLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
          const Spacer(),
          Text('kcal ${s.totals.calories.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.black54)),
        ]),
        const SizedBox(height: 8),
        ...s.meals.map((m) {
          final time = TimeOfDay.fromDateTime(m.ateAt.toLocal()).format(ctx);
          final totalCal =
          m.items.fold<double>(0, (sum, it) => sum + it.calories);
          final safe = m.items.every((it) => it.safe);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: MealCard(
              meal: m,
              timeLabel: time,
              totalCalories: totalCal,
              isSafe: safe,
              prov: mealsProv,
              ref: ref, // ✅ pass the real WidgetRef here
            ),
          );
        }),
      ]),
    );
  }

  static Widget _empty(String msg) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.black12),
    ),
    child: Row(children: [
      const Icon(Icons.info_outline, color: Colors.grey),
      const SizedBox(width: 8),
      Expanded(child: Text(msg, style: const TextStyle(color: Colors.black54))),
    ]),
  );
}


// ————————————————————————————————————————————————————————————
// Monthly View
// ————————————————————————————————————————————————————————————
class _MonthlyView extends ConsumerWidget {
  const _MonthlyView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hist = ref.watch(mealHistoryProvider);
    final ctl = ref.read(mealHistoryProvider.notifier);

    final monthLabel = DateFormat('MMMM yyyy').format(hist.selectedMonth);
    final counts = hist.monthlyCounts;
    final t = hist.monthlyTotals;

    final tiles = <_TileSpec>[
      _TileSpec(bg: AppColors.sky50,     title: 'Calories (sum)', value: t.calories.toStringAsFixed(0), accent: const Color(0xFF075985)),
      _TileSpec(bg: AppColors.emerald50, title: 'Protein (g)',    value: t.protein.toStringAsFixed(0),  accent: const Color(0xFF065F46)),
      _TileSpec(bg: const Color(0xFFF3E8FF), title: 'Carbs (g)', value: t.carbs.toStringAsFixed(0),    accent: const Color(0xFF6B21A8)),
      _TileSpec(bg: const Color(0xFFFFF7ED), title: 'Fat (g)',   value: t.fat.toStringAsFixed(0),      accent: const Color(0xFF92400E)),
      _TileSpec(bg: const Color(0xFFEFF6FF), title: 'Sodium (mg)', value: t.sodium.toStringAsFixed(0), accent: const Color(0xFF1E40AF)),
      _TileSpec(bg: const Color(0xFFFFF1F2), title: 'Sugar (g)', value: t.sugar.toStringAsFixed(0),    accent: const Color(0xFFBE123C)),
      _TileSpec(bg: const Color(0xFFEDE9FE), title: 'Days Logged', value: '${counts.daysCounted}',      accent: const Color(0xFF6B21A8)),
      _TileSpec(bg: const Color(0xFFEFFDF5), title: 'Items Logged', value: '${counts.itemCount}',      accent: const Color(0xFF065F46)),
    ];

    return Card(
      color: AppColors.cardBackground,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: const [
            Icon(Icons.insights, color: AppColors.emerald600, size: 20),
            SizedBox(width: 8),
            Text('Monthly Overview', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          ]),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: AppColors.emerald600, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: hist.selectedMonth,
                      firstDate: DateTime(2020, 1, 1),
                      lastDate: DateTime(now.year, now.month, now.day),
                    );
                    if (picked != null) {
                      ctl.changeMonth(DateTime(picked.year, picked.month, 1));
                    }
                  },
                  child: Row(children: [
                    Text(monthLabel, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_drop_down, size: 20, color: Colors.black54),
                  ]),
                ),
              ),
              IconButton(icon: const Icon(Icons.chevron_left), tooltip: 'Previous month', onPressed: ctl.prevMonth),
              IconButton(icon: const Icon(Icons.chevron_right), tooltip: 'Next month',     onPressed: ctl.nextMonth),
            ],
          ),
          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tiles.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisExtent: 78, crossAxisSpacing: 12, mainAxisSpacing: 12,
            ),
            itemBuilder: (_, i) => _MetricTile(spec: tiles[i]),
          ),
          if (counts.safeItems + counts.unsafeItems > 0) ...[
            const SizedBox(height: 8),
            Wrap(spacing: 12, runSpacing: 6, children: [
              _chip('Safe: ${counts.safeItems}'),
              _chip('Unsafe: ${counts.unsafeItems}'),
            ]),
          ],

          const SizedBox(height: 16),
          _MonthGroupedList(),
        ]),
      ),
    );
  }

  static Widget _chip(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: AppColors.emerald100, borderRadius: BorderRadius.circular(20)),
    child: Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF065F46))),
  );
}

class _MonthGroupedList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hist = ref.watch(mealHistoryProvider);
    final meals = hist.mealsInMonth..sort((a,b)=>a.ateAt.compareTo(b.ateAt));
    if (meals.isEmpty) {
      return _empty('No meals in this month.');
    }

    // Group by day
    final byDay = <String, List<Meal>>{};
    for (final m in meals) {
      final d = m.ateAt.toLocal();
      final key = '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
      byDay.putIfAbsent(key, () => []).add(m);
    }

    final entries = byDay.entries.toList()
      ..sort((a,b)=>a.key.compareTo(b.key));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: entries.map((e) {
        final parts = e.key.split('-').map(int.parse).toList();
        final day = DateTime(parts[0], parts[1], parts[2]);
        final pretty = DateFormat('y-MM-dd (EEE)').format(day);

        final t = _totalsFor(e.value);
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(pretty, style: const TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('kcal ${t.calories.toStringAsFixed(0)}', style: const TextStyle(color: Colors.black54)),
            ]),
            const SizedBox(height: 8),
            Wrap(spacing: 10, runSpacing: 6, children: [
              _chipMini('P ${t.protein.toStringAsFixed(0)}g'),
              _chipMini('C ${t.carbs.toStringAsFixed(0)}g'),
              _chipMini('F ${t.fat.toStringAsFixed(0)}g'),
              _chipMini('Na ${t.sodium.toStringAsFixed(0)}mg'),
              _chipMini('Sug ${t.sugar.toStringAsFixed(0)}g'),
            ]),
          ]),
        );
      }).toList(),
    );
  }

  static MealTotals _totalsFor(List<Meal> meals) {
    double cals=0, p=0, c=0, f=0, na=0, s=0;
    for (final m in meals) {
      for (final it in m.items) {
        cals += it.calories; p += it.protein; c += it.carbs; f += it.fat; na += it.sodium; s += it.sugar;
      }
    }
    return MealTotals(calories: cals, protein: p, carbs: c, fat: f, sodium: na, sugar: s);
  }

  static Widget _chipMini(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.emerald100, borderRadius: BorderRadius.circular(16),
    ),
    child: Text(text, style: const TextStyle(fontSize: 11, color: Color(0xFF065F46))),
  );

  static Widget _empty(String msg) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12),
    ),
    child: Row(children: [
      const Icon(Icons.info_outline, color: Colors.grey),
      const SizedBox(width: 8),
      Expanded(child: Text(msg, style: const TextStyle(color: Colors.black54))),
    ]),
  );
}

// ————————————————————————————————————————————————————————————
// Shared small UI bits (tiles)
// ————————————————————————————————————————————————————————————
class _TileSpec {
  final Color bg;
  final String title;
  final String value;
  final Color accent;
  _TileSpec({required this.bg, required this.title, required this.value, required this.accent});
}

class _MetricTile extends StatelessWidget {
  final _TileSpec spec;
  const _MetricTile({required this.spec});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: spec.bg, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(spec.value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: spec.accent)),
        const SizedBox(height: 4),
        Text(spec.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.black54), maxLines: 1, overflow: TextOverflow.ellipsis),
      ]),
    );
  }
}
