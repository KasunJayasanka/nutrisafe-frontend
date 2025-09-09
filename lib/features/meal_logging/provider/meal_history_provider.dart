import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:frontend_v2/core/services/api_service.dart';
import '../../meal_logging/data/meal_model.dart';
import '../../meal_logging/repository/meal_repository.dart';
import '../../meal_logging/service/meal_service.dart';

enum HistoryMode { weekly, monthly }

class MealTotals {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double sodium;
  final double sugar;

  const MealTotals({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.sodium,
    required this.sugar,
  });

  MealTotals add(MealTotals o) => MealTotals(
    calories: calories + o.calories,
    protein:  protein  + o.protein,
    carbs:    carbs    + o.carbs,
    fat:      fat      + o.fat,
    sodium:   sodium   + o.sodium,
    sugar:    sugar    + o.sugar,
  );

  static MealTotals zero() => const MealTotals(
    calories: 0, protein: 0, carbs: 0, fat: 0, sodium: 0, sugar: 0,
  );
}

class DaySummary {
  final DateTime day;
  final List<Meal> meals;
  final MealTotals totals;
  final int itemCount;
  final int safeItems;
  final int unsafeItems;

  DaySummary({
    required this.day,
    required this.meals,
    required this.totals,
    required this.itemCount,
    required this.safeItems,
    required this.unsafeItems,
  });
}

class MealHistoryProvider extends ChangeNotifier {
  final MealRepository _repo;

  MealHistoryProvider(ApiService api) : _repo = MealRepository(MealService(api));

  bool isLoading = false;
  String? error;

  // Raw cache
  List<Meal> _allMeals = [];

  // UI state
  HistoryMode mode = HistoryMode.weekly;

  // Weekly state
  DateTime _weekMonday = _mondayOf(DateTime.now());
  DateTime _selectedDate = DateTime.now();

  // Monthly state
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);

  // Public getters
  DateTime get weekMonday => _weekMonday;
  DateTime get selectedDate => _selectedDate;
  DateTime get selectedMonth => _selectedMonth;

  Future<void> init() async {
    await loadAll();
  }

  Future<void> loadAll() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      _allMeals = await _repo.getMeals();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setMode(HistoryMode m) {
    if (mode != m) {
      mode = m;
      notifyListeners();
    }
  }

  // —— Weekly controls ——
  void changeWeek(DateTime newMonday) {
    _weekMonday = _mondayOf(newMonday);
    if (!_isSameWeek(_selectedDate, _weekMonday)) {
      _selectedDate = _weekMonday;
    }
    notifyListeners();
  }

  void prevWeek() => changeWeek(_weekMonday.subtract(const Duration(days: 7)));
  void nextWeek() => changeWeek(_weekMonday.add(const Duration(days: 7)));

  void selectDay(DateTime d) {
    _selectedDate = DateTime(d.year, d.month, d.day);
    if (!_isSameWeek(_selectedDate, _weekMonday)) {
      _weekMonday = _mondayOf(_selectedDate);
    }
    notifyListeners();
  }

  // —— Monthly controls ——
  void changeMonth(DateTime firstOfMonth) {
    _selectedMonth = DateTime(firstOfMonth.year, firstOfMonth.month, 1);
    notifyListeners();
  }

  void prevMonth() {
    final m = DateTime(_selectedMonth.year, _selectedMonth.month - 1, 1);
    changeMonth(m);
  }

  void nextMonth() {
    final m = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);
    changeMonth(m);
  }

  // —— Data slices ——
  List<Meal> get mealsInWeek {
    final start = _weekMonday;
    final end = start.add(const Duration(days: 7)); // exclusive
    return _allMeals.where((m) {
      final d = m.ateAt.toLocal();
      return !d.isBefore(start) && d.isBefore(end);
    }).toList()
      ..sort((a, b) => a.ateAt.compareTo(b.ateAt));
  }

  List<DaySummary> get daySummariesInWeek {
    final byDay = <String, List<Meal>>{};
    for (final m in mealsInWeek) {
      final d = m.ateAt.toLocal();
      final key = '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
      byDay.putIfAbsent(key, () => []).add(m);
    }

    final out = <DaySummary>[];
    for (final entry in byDay.entries) {
      final parts = entry.key.split('-').map(int.parse).toList(); // y-m-d
      final day = DateTime(parts[0], parts[1], parts[2]);

      final totals = _totalsForMeals(entry.value);
      final counts = _safetyCounts(entry.value);

      out.add(DaySummary(
        day: day,
        meals: entry.value..sort((a,b)=>a.ateAt.compareTo(b.ateAt)),
        totals: totals,
        itemCount: counts.$1,
        safeItems: counts.$2,
        unsafeItems: counts.$3,
      ));
    }
    out.sort((a, b) => a.day.compareTo(b.day));
    return out;
  }

  // Selected day view (weekly)
  DaySummary? get selectedDaySummary {
    final d = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    return daySummariesInWeek.firstWhere(
          (s) => _sameDay(s.day, d),
      orElse: () => DaySummary(
        day: d, meals: const [], totals: MealTotals.zero(),
        itemCount: 0, safeItems: 0, unsafeItems: 0,
      ),
    );
  }

  // Monthly aggregates
  List<Meal> get mealsInMonth {
    final start = _selectedMonth; // first
    final nextMonth = DateTime(start.year, start.month + 1, 1);
    return _allMeals.where((m) {
      final d = m.ateAt.toLocal();
      return !d.isBefore(start) && d.isBefore(nextMonth);
    }).toList();
  }

  MealTotals get monthlyTotals => _totalsForMeals(mealsInMonth);

  ({int daysCounted, int itemCount, int safeItems, int unsafeItems}) get monthlyCounts {
    final inMonth = mealsInMonth;
    final dayKeys = inMonth
        .map((m) {
      final d = m.ateAt.toLocal();
      return '${d.year}-${d.month}-${d.day}';
    })
        .toSet();
    final counts = _safetyCounts(inMonth);
    return (daysCounted: dayKeys.length, itemCount: counts.$1, safeItems: counts.$2, unsafeItems: counts.$3);
  }

  // —— helpers ——
  static DateTime _mondayOf(DateTime d) =>
      DateTime(d.year, d.month, d.day).subtract(Duration(days: d.weekday - 1));

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool _isSameWeek(DateTime day, DateTime monday) {
    final start = monday;
    final end = monday.add(const Duration(days: 7));
    return !day.isBefore(start) && day.isBefore(end);
  }

  static MealTotals _totalsForMeals(List<Meal> meals) {
    double cals=0, p=0, c=0, f=0, na=0, s=0;
    for (final m in meals) {
      for (final it in m.items) {
        cals += it.calories;
        p    += it.protein;
        c    += it.carbs;
        f    += it.fat;
        na   += it.sodium;
        s    += it.sugar;
      }
    }
    return MealTotals(calories: cals, protein: p, carbs: c, fat: f, sodium: na, sugar: s);
  }

  /// returns (itemCount, safeItems, unsafeItems)
  static (int, int, int) _safetyCounts(List<Meal> meals) {
    int total=0, safe=0, unsafe=0;
    for (final m in meals) {
      for (final it in m.items) {
        total++;
        if (it.safe) safe++; else unsafe++;
      }
    }
    return (total, safe, unsafe);
  }
}

// —— Provider bind ——
final mealHistoryProvider = ChangeNotifierProvider<MealHistoryProvider>((ref) {
  final api = ref.read(apiProvider);
  final p = MealHistoryProvider(api);
  // fire & forget init
  p.init();
  return p;
});
