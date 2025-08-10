import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/features/home/widgets/quick_stat_card.dart';

class QuickStatsGrid extends StatelessWidget {
  final int caloriesConsumed;
  final int caloriesTarget;
  final int hydrationConsumed;
  final int hydrationTarget;

  const QuickStatsGrid({
    Key? key,
    required this.caloriesConsumed,
    required this.caloriesTarget,
    required this.hydrationConsumed,
    required this.hydrationTarget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final remainingCalories = caloriesTarget - caloriesConsumed;

    return Row(
      children: [
        // ─── Calories ─────────────────────────────
        Expanded(
          child: QuickStatCard(
            icon: Icons.local_fire_department,
            iconBackground: AppColors.emerald500,
            title: 'Calories',
            value: '$caloriesConsumed',
            unitLabel: 'kcal',
            target: caloriesTarget,
            extraLine: 'Remaining: $remainingCalories kcal',
            colors: const [
              AppColors.emerald50,
              AppColors.emerald100,
            ],
          ),
        ),
        const SizedBox(width: 12),

        // ─── Hydration ─────────────────────────────
        Expanded(
          child: QuickStatCard(
            icon: Icons.water_drop,
            iconBackground: AppColors.sky500,
            title: 'Hydration',
            value: '$hydrationConsumed',
            unitLabel: 'glasses', // or 'cups' if you prefer
            target: hydrationTarget,
            extraLine: null,
            colors: const [
              AppColors.sky50,
              AppColors.sky100,
            ],
          ),
        ),
      ],
    );
  }
}
