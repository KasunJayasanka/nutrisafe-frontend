import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../provider/goals_provider.dart';
import 'goals_section_card.dart';

class GoalsByDateSheet extends ConsumerWidget {
  final String yyyyMmDd;
  const GoalsByDateSheet({super.key, required this.yyyyMmDd});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(goalsByDateProvider(yyyyMmDd));

    return Container(
      color: Colors.white, // fallback white background
      child: async.when(
        loading: () => const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Error: $e'),
        ),
        data: (resp) {
          final g = resp.goals;
          final p = resp.progress;

          return SafeArea(
            child: Column(
              children: [
                // ── HEADER with close button ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.insights, color: Colors.black87),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Details – $yyyyMmDd',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black87),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // ── SCROLLABLE CONTENT ──
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: Column(
                      children: [
                        GoalsSectionCard(
                          title: 'Calories',
                          icon: Icons.local_fire_department,
                          iconColor: Colors.orange,
                          isEditing: false,
                          unitLabel: 'kcal',
                          targetValue: g.calories,
                          currentValue: p.calories.consumed,
                        ),
                        const SizedBox(height: 8),
                        GoalsSectionCard(
                          title: 'Protein',
                          icon: Icons.fitness_center,
                          iconColor: Colors.blueGrey,
                          isEditing: false,
                          unitLabel: 'g',
                          targetValue: g.protein,
                          currentValue: p.protein.consumed,
                        ),
                        const SizedBox(height: 8),
                        GoalsSectionCard(
                          title: 'Carbohydrates',
                          icon: Icons.bubble_chart,
                          iconColor: Colors.teal,
                          isEditing: false,
                          unitLabel: 'g',
                          targetValue: g.carbs,
                          currentValue: p.carbs.consumed,
                        ),
                        const SizedBox(height: 8),
                        GoalsSectionCard(
                          title: 'Fat',
                          icon: Icons.bolt,
                          iconColor: Colors.amber,
                          isEditing: false,
                          unitLabel: 'g',
                          targetValue: g.fat,
                          currentValue: p.fat.consumed,
                        ),
                        const SizedBox(height: 8),
                        GoalsSectionCard(
                          title: 'Sodium',
                          icon: Icons.water_drop_outlined,
                          iconColor: Colors.indigo,
                          isEditing: false,
                          unitLabel: 'mg',
                          targetValue: g.sodium,
                          currentValue: p.sodium.consumed,
                        ),
                        const SizedBox(height: 8),
                        GoalsSectionCard(
                          title: 'Sugar',
                          icon: Icons.cake_outlined,
                          iconColor: Colors.pink,
                          isEditing: false,
                          unitLabel: 'g',
                          targetValue: g.sugar,
                          currentValue: p.sugar.consumed,
                        ),
                        const SizedBox(height: 8),
                        GoalsSectionCard(
                          title: 'Hydration',
                          icon: Icons.opacity,
                          iconColor: Colors.blue,
                          isEditing: false,
                          unitLabel: 'glasses',
                          targetValue: g.hydration,
                          currentValue: p.hydration.consumed,
                        ),
                        const SizedBox(height: 8),
                        GoalsSectionCard(
                          title: 'Exercise',
                          icon: Icons.directions_run,
                          iconColor: Colors.purple,
                          isEditing: false,
                          unitLabel: 'min',
                          targetValue: g.exercise,
                          currentValue: p.exercise.consumed,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
