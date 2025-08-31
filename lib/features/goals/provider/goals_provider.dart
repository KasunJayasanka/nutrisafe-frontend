import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/goals_model.dart';
import '../data/goals_response.dart';
import '../repository/goals_repository.dart';
import '../data/daily_progress_model.dart';

final goalsAsyncProvider = FutureProvider<GoalsResponse>((ref) {
  return ref.read(goalsRepositoryProvider).fetchGoals();
});

class GoalsEditState {
  final bool isEditing;
  final Goals current;
  final GoalsProgress progress;
  GoalsEditState({required this.isEditing, required this.current, required this.progress});

  GoalsEditState copy({bool? isEditing, Goals? current, GoalsProgress? progress}) =>
      GoalsEditState(
        isEditing: isEditing ?? this.isEditing,
        current: current ?? this.current,
        progress: progress ?? this.progress,
      );
}

class GoalsNotifier extends StateNotifier<AsyncValue<GoalsEditState>> {
  final GoalsRepository repo;
  GoalsNotifier(this.repo) : super(const AsyncLoading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final resp = await repo.fetchGoals();
      state = AsyncValue.data(GoalsEditState(
        isEditing: false,
        current: resp.goals,
        progress: resp.progress,
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void toggleEdit(bool editing) {
    state = state.whenData((s) => s.copy(isEditing: editing));
  }

  void updateField(String key, int value) {
    state = state.whenData((s) {
      final updated = switch (key) {
        'calories' => s.current.copyWith(calories: value),
        'protein'  => s.current.copyWith(protein: value),
        'carbs'    => s.current.copyWith(carbs: value),
        'fat'      => s.current.copyWith(fat: value),
        'sodium'   => s.current.copyWith(sodium: value),
        'sugar'    => s.current.copyWith(sugar: value),
        'hydration'=> s.current.copyWith(hydration: value),
        'exercise' => s.current.copyWith(exercise: value),
        _ => s.current,
      };
      return s.copy(current: updated);
    });
  }

  void applyTemplate({
    required int calories,
    required int protein,
    required int carbs,
    required int fat,
    required int sodiumMg,
    required int sugarG,
    required int hydrationGlasses,
    required int exerciseMin,
  }) {
    state = state.whenData((s) {
      final updated = s.current.copyWith(
        calories: calories,
        protein: protein,
        carbs: carbs,
        fat: fat,
        sodium: sodiumMg,
        sugar: sugarG,
        hydration: hydrationGlasses,
        exercise: exerciseMin,
      );
      return s.copy(current: updated, isEditing: true); // enter edit mode
    });
  }


  Future<void> save() async {
    final value = state.valueOrNull;
    if (value == null) return;
    await repo.updateGoals(value.current.toPatchJson());
    // refresh progress for today
    final refreshed = await repo.fetchGoals();
    state = AsyncValue.data(GoalsEditState(
      isEditing: false,
      current: refreshed.goals,
      progress: refreshed.progress,
    ));
  }

  Future<void> updateDailyActivity({int? hydration, int? exercise}) async {
    await repo.updateDailyActivity(hydration: hydration, exercise: exercise);
    final refreshed = await repo.fetchGoals();
    state = AsyncValue.data(GoalsEditState(
      isEditing: false,
      current: refreshed.goals,
      progress: refreshed.progress,
    ));
  }
}

final goalsNotifierProvider =
StateNotifierProvider<GoalsNotifier, AsyncValue<GoalsEditState>>((ref) {
  return GoalsNotifier(ref.read(goalsRepositoryProvider));
});

final dailyProgressListProvider = FutureProvider<List<DailyProgressItem>>((ref) {
  return ref.read(goalsRepositoryProvider).fetchAllDailyProgress();
});

// Fetch a specific day’s goals+progress (for the bottom sheet)
final goalsByDateProvider =
FutureProvider.family<GoalsResponse, String>((ref, yyyyMmDd) async {
  return ref.read(goalsRepositoryProvider).fetchGoalsByDate(yyyyMmDd);
});

int _kcalToGrams(double kcal, {required int kcalPerGram}) =>
    (kcal / kcalPerGram).round();

class TemplateMath {
  static Map<String, int> compute({
    required int kcal,
    required double pPct, // 0.20 = 20%
    required double cPct,
    required double fPct,
    int sodiumCapMg = 2300,
    int hydrationGlasses = 8,
    int exerciseMin = 30,
  }) {
    final pGr = _kcalToGrams(kcal * pPct, kcalPerGram: 4);
    final cGr = _kcalToGrams(kcal * cPct, kcalPerGram: 4);
    final fGr = _kcalToGrams(kcal * fPct, kcalPerGram: 9);
    final sugarMaxGr = _kcalToGrams(kcal * 0.10, kcalPerGram: 4); // <10% kcal
    return {
      'calories': kcal,
      'protein': pGr,
      'carbs': cGr,
      'fat': fGr,
      'sodium': sodiumCapMg,
      'sugar': sugarMaxGr,
      'hydration': hydrationGlasses,
      'exercise': exerciseMin,
    };
  }
}
