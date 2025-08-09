import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/core/widgets/bottom_nav_bar.dart'; // ⬅️ add this
import 'package:frontend_v2/core/widgets/gradient_app_bar.dart';

import '../provider/goals_provider.dart';
import '../widgets/goals_header.dart';
import '../widgets/goals_section_card.dart';
import '../widgets/goal_templates.dart';
import '../widgets/gradient_border_section.dart';

import 'daily_nutrition_screen.dart';
import 'goals_history_screen.dart';
import 'package:frontend_v2/features/auth/widgets/gradient_button.dart';

class GoalsScreen extends HookConsumerWidget {
  const GoalsScreen({super.key});

  InputDecoration _activityInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.sky400, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(goalsNotifierProvider);
    final notifier = ref.read(goalsNotifierProvider.notifier);

    final hydrationCtl = useTextEditingController();
    final exerciseCtl = useTextEditingController();

    return Scaffold(
      appBar: GradientAppBar(
        title: 'Goals',
        actions: [
          IconButton(
            tooltip: 'History',
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const GoalsHistoryScreen()),
              );
            },
          ),
        ],
      ),

      // ⬇️ Add your bottom nav bar here
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2, // Goals
        onTap: (idx) {
          if (idx == 2) return; // already on Goals
          switch (idx) {
            case 0:
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/food');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/analytics');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [AppColors.emerald50, AppColors.sky50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (s) {
              useEffect(() {
                hydrationCtl.text = s.current.hydration.toString();
                exerciseCtl.text = s.current.exercise.toString();
                return null;
              }, [s.current.hydration, s.current.exercise]);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const GoalsHeader(),
                    const SizedBox(height: 16),

                    // Daily Nutrition
                    GradientBorderSection(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Icon(Icons.local_fire_department, color: Colors.orange),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Daily Nutrition',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 40, width: 110,
                                  child: GradientButton(
                                    text: s.isEditing ? 'Save' : 'Edit',
                                    onPressed: () async {
                                      if (s.isEditing) {
                                        await notifier.save();
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Goals updated successfully')),
                                          );
                                        }
                                      } else {
                                        notifier.toggleEdit(true);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  height: 40, width: 120,
                                  child: GradientButton(
                                    text: 'View',
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_) => const DailyNutritionScreen()),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ]),
                          const SizedBox(height: 8),

                          SizedBox(
                            height: 420,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  GoalsSectionCard(
                                    title: 'Calories',
                                    icon: Icons.local_fire_department,
                                    iconColor: Colors.orange,
                                    isEditing: s.isEditing,
                                    unitLabel: 'kcal',
                                    targetValue: s.current.calories,
                                    currentValue: s.progress.calories.consumed,
                                    onTargetChanged: (v) => notifier.updateField('calories', v),
                                  ),
                                  const SizedBox(height: 12),
                                  GoalsSectionCard(
                                    title: 'Protein',
                                    icon: Icons.fitness_center,
                                    iconColor: Colors.blueGrey,
                                    isEditing: s.isEditing,
                                    unitLabel: 'g',
                                    targetValue: s.current.protein,
                                    currentValue: s.progress.protein.consumed,
                                    onTargetChanged: (v) => notifier.updateField('protein', v),
                                  ),
                                  const SizedBox(height: 12),
                                  GoalsSectionCard(
                                    title: 'Carbohydrates',
                                    icon: Icons.bubble_chart,
                                    iconColor: Colors.teal,
                                    isEditing: s.isEditing,
                                    unitLabel: 'g',
                                    targetValue: s.current.carbs,
                                    currentValue: s.progress.carbs.consumed,
                                    onTargetChanged: (v) => notifier.updateField('carbs', v),
                                  ),
                                  const SizedBox(height: 12),
                                  GoalsSectionCard(
                                    title: 'Fat',
                                    icon: Icons.bolt,
                                    iconColor: Colors.amber,
                                    isEditing: s.isEditing,
                                    unitLabel: 'g',
                                    targetValue: s.current.fat,
                                    currentValue: s.progress.fat.consumed,
                                    onTargetChanged: (v) => notifier.updateField('fat', v),
                                  ),
                                  const SizedBox(height: 12),
                                  GoalsSectionCard(
                                    title: 'Sodium',
                                    icon: Icons.water_drop_outlined,
                                    iconColor: Colors.indigo,
                                    isEditing: s.isEditing,
                                    unitLabel: 'mg',
                                    targetValue: s.current.sodium,
                                    currentValue: s.progress.sodium.consumed,
                                    onTargetChanged: (v) => notifier.updateField('sodium', v),
                                  ),
                                  const SizedBox(height: 12),
                                  GoalsSectionCard(
                                    title: 'Sugar',
                                    icon: Icons.cake_outlined,
                                    iconColor: Colors.pink,
                                    isEditing: s.isEditing,
                                    unitLabel: 'g',
                                    targetValue: s.current.sugar,
                                    currentValue: s.progress.sugar.consumed,
                                    onTargetChanged: (v) => notifier.updateField('sugar', v),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Daily Activity (Hydration + Exercise + Update Today)
                    GradientBorderSection(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Icon(Icons.water_drop, color: Colors.blue),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Daily Activity',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ]),
                          const SizedBox(height: 8),

                          GoalsSectionCard(
                            title: 'Hydration',
                            icon: Icons.opacity,
                            iconColor: Colors.blue,
                            isEditing: s.isEditing,
                            unitLabel: 'glasses',
                            targetValue: s.current.hydration,
                            currentValue: s.progress.hydration.consumed,
                            onTargetChanged: (v) => notifier.updateField('hydration', v),
                          ),
                          const SizedBox(height: 12),
                          GoalsSectionCard(
                            title: 'Exercise',
                            icon: Icons.directions_run,
                            iconColor: Colors.purple,
                            isEditing: s.isEditing,
                            unitLabel: 'min',
                            targetValue: s.current.exercise,
                            currentValue: s.progress.exercise.consumed,
                            onTargetChanged: (v) => notifier.updateField('exercise', v),
                          ),

                          const SizedBox(height: 12),
                          const Divider(height: 24),

                          Text("Update Today's Activity",
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 12),
                          Row(children: [
                            Expanded(
                              child: TextFormField(
                                controller: hydrationCtl,
                                keyboardType: TextInputType.number,
                                decoration: _activityInputDecoration('Hydration (glasses)'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: exerciseCtl,
                                keyboardType: TextInputType.number,
                                decoration: _activityInputDecoration('Exercise (min)'),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 12),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.sky400, width: 1),
                            ),
                            child: SizedBox(
                              height: 46,
                              width: double.infinity,
                              child: GradientButton(
                                text: 'Save Activity',
                                onPressed: () async {
                                  final hydration = int.tryParse(hydrationCtl.text);
                                  final exercise = int.tryParse(exerciseCtl.text);
                                  await notifier.updateDailyActivity(
                                    hydration: hydration,
                                    exercise: exercise,
                                  );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Daily activity updated')),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (!s.isEditing)
                      GoalTemplates(
                        onApply: (key) {
                          switch (key) {
                            case 'weight_loss':
                              notifier.updateField('calories', (s.current.calories * 0.85).round());
                              notifier.updateField('carbs', (s.current.carbs * 0.9).round());
                              break;
                            case 'muscle_gain':
                              notifier.updateField('calories', (s.current.calories * 1.1).round());
                              notifier.updateField('protein', (s.current.protein * 1.15).round());
                              break;
                            case 'maintenance':
                              break;
                          }
                          notifier.toggleEdit(true);
                        },
                      ),

                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
