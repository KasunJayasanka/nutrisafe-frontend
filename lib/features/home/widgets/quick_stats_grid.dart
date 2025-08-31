import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/features/home/widgets/quick_stat_card.dart';
import 'package:frontend_v2/features/home/data/dashboard_models.dart';

/// Render 8 quick stats as a horizontal carousel-like row that always shows 2 cards.
class QuickStatsGrid extends StatelessWidget {
  final Progress progress;      // from GoalsByDateResponse.progress
  final DailyGoals goals;       // from GoalsByDateResponse.goals

  const QuickStatsGrid({
    Key? key,
    required this.progress,
    required this.goals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build the 8 entries from your progress + goals
    final items = <_Stat>[
      _Stat(
        title: 'Hydration',
        consumed: progress.hydration.consumed,
        target:   progress.hydration.goal,
        unit: 'glasses',
        icon: Icons.water_drop,
        iconBg: AppColors.sky500,
        bg: const [AppColors.sky50, AppColors.sky100],
      ),
      _Stat(
        title: 'Exercise',
        consumed: progress.exercise.consumed,
        target:   progress.exercise.goal,
        unit: 'min',
        icon: Icons.directions_run,
        iconBg: AppColors.emerald500,
        bg: const [AppColors.emerald50, AppColors.emerald100],
      ),
      _Stat(
        title: 'Calories',
        consumed: progress.calories.consumed,
        target:   progress.calories.goal,
        unit: 'kcal',
        icon: Icons.local_fire_department,
        iconBg: AppColors.emerald500,
        bg: const [AppColors.emerald50, AppColors.emerald100],
      ),
      _Stat(
        title: 'Protein',
        consumed: progress.protein.consumed,
        target:   progress.protein.goal,
        unit: 'g',
        icon: Icons.fitness_center,
        iconBg: AppColors.emerald700,
        bg: const [AppColors.emerald50, AppColors.emerald100],
      ),
      _Stat(
        title: 'Carbs',
        consumed: progress.carbs.consumed,
        target:   progress.carbs.goal,
        unit: 'g',
        icon: Icons.rice_bowl_outlined,
        iconBg: AppColors.amber600,
        bg: [AppColors.amber50, AppColors.amber100],
      ),
      _Stat(
        title: 'Fat',
        consumed: progress.fat.consumed,
        target:   progress.fat.goal,
        unit: 'g',
        icon: Icons.oil_barrel_outlined,
        iconBg: AppColors.rose600,
        bg: [AppColors.rose50, AppColors.rose100],
      ),
      _Stat(
        title: 'Sodium',
        consumed: progress.sodium.consumed,
        target:   progress.sodium.goal,
        unit: 'mg',
        icon: Icons.invert_colors_off_outlined,
        iconBg: AppColors.indigo600,
        bg: [AppColors.indigo50, AppColors.indigo100],
      ),
      _Stat(
        title: 'Sugar',
        consumed: progress.sugar.consumed,
        target:   progress.sugar.goal,
        unit: 'g',
        icon: Icons.cake_outlined,
        iconBg: AppColors.purple600,
        bg: [AppColors.purple50, AppColors.purple100],
      ),

    ];

    // Horizontal “carousel” that always shows two cards
    return LayoutBuilder(
      builder: (context, constraints) {

        const gap = 12.0;            // space between cards
        const sidePad = 16.0;
        final cardWidth =
            (constraints.maxWidth - (sidePad * 2) - gap) / 2; // exactly 2 visible

        return SizedBox(
          height: 120, // match your card height
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(4),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: gap),
            itemBuilder: (_, i) {
              final s = items[i];
              final remaining = max(0, s.target.round() - s.consumed.round());
              return SizedBox(
                width: cardWidth,
                child: QuickStatCard(
                  icon: s.icon,
                  iconBackground: s.iconBg,
                  title: s.title,
                  value: '${s.consumed.round()}',
                  unitLabel: s.unit,
                  target: s.target.round(),
                  extraLine: 'Remaining: $remaining ${s.unit}',
                  colors: s.bg,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _Stat {
  final String title;
  final double consumed;
  final double target;
  final String unit;
  final IconData icon;
  final Color iconBg;
  final List<Color> bg;

  _Stat({
    required this.title,
    required this.consumed,
    required this.target,
    required this.unit,
    required this.icon,
    required this.iconBg,
    required this.bg,
  });
}
