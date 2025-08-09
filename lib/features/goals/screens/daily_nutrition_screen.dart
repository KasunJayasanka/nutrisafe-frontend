import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import '../../../core/widgets/gradient_app_bar.dart';
import '../provider/goals_provider.dart';
import '../widgets/gradient_border_section.dart';
import '../widgets/goals_section_card.dart';

class DailyNutritionScreen extends HookConsumerWidget {
  const DailyNutritionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(goalsNotifierProvider);
    final notifier = ref.read(goalsNotifierProvider.notifier);

    // 1) Use a controller the Scrollbar can hook onto
    final scrollController = useScrollController();

    // 2) A local theme so the thumb is definitely visible over your white panel
    final localScrollbarTheme = Theme.of(context).copyWith(
      scrollbarTheme: ScrollbarThemeData(
        thickness: MaterialStateProperty.all(6),
        radius: const Radius.circular(8),
        trackVisibility: MaterialStateProperty.all(true),
        thumbVisibility: MaterialStateProperty.all(true),
        thumbColor: MaterialStateProperty.resolveWith((states) {
          // If actively dragging / scrolling → higher opacity
          if (states.contains(MaterialState.dragged)) {
            return AppColors.indigo500.withOpacity(0.9);
          }
          // Idle → lower opacity
          return AppColors.indigo500.withOpacity(0.3);
        }),
        trackColor: MaterialStateProperty.all(const Color(0xFFE5E7EB)),
        trackBorderColor: MaterialStateProperty.all(Colors.transparent),
      ),
    );

    return Scaffold(
      appBar: const GradientAppBar(
        title: 'Daily Nutrition Progress',
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [AppColors.emerald50, AppColors.sky50],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (s) => Theme( // 3) Apply local Scrollbar theme
                data: localScrollbarTheme,
                child: GradientBorderSection(
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    interactive: true,
                    notificationPredicate: (notif) => notif.metrics.axis == Axis.vertical,
                    child: ListView(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(), // 4) Force scrollable
                      padding: const EdgeInsets.only(bottom: 16),
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.local_fire_department, color: Colors.orange),
                            const SizedBox(width: 8),
                            Text(
                              'Your daily nutrition progress',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

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
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
