import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/features/home/data/dashboard_models.dart';

class ProgressRow extends StatelessWidget {
  final String label;
  final double consumed;
  final double target;
  final Color color;

  const ProgressRow({
    super.key,
    required this.label,
    required this.consumed,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // clamp to [0,1] for the bar; text still shows % of target (0–100)
    final ratio = target <= 0 ? 0.0 : (consumed / target);
    final percentage = ratio.clamp(0.0, 1.0);
    final percentText = (ratio * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
              Text('$percentText%',
                  style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class TodayProgressSection extends StatelessWidget {
  /// Pass the whole Progress object so we can render everything.
  final Progress progress;

  const TodayProgressSection({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final p = progress;

    return Card(
      color: Colors.white,
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.trending_up, color: AppColors.emerald600),
              title: Text(
                "Today's Goal Progress",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
              ),
            ),

            // All 8 metrics
            ProgressRow(label: 'Calories',  consumed: p.calories.consumed,  target: p.calories.goal,  color: AppColors.black),
            ProgressRow(label: 'Protein',   consumed: p.protein.consumed,   target: p.protein.goal,   color: AppColors.black),
            ProgressRow(label: 'Carbs',     consumed: p.carbs.consumed,     target: p.carbs.goal,     color: AppColors.black),
            ProgressRow(label: 'Fat',       consumed: p.fat.consumed,       target: p.fat.goal,       color: AppColors.black),
            ProgressRow(label: 'Sodium',    consumed: p.sodium.consumed,    target: p.sodium.goal,    color: AppColors.black),
            ProgressRow(label: 'Sugar',     consumed: p.sugar.consumed,     target: p.sugar.goal,     color: AppColors.black),
            ProgressRow(label: 'Hydration', consumed: p.hydration.consumed, target: p.hydration.goal, color: AppColors.black),
            ProgressRow(label: 'Exercise',  consumed: p.exercise.consumed,  target: p.exercise.goal,  color: AppColors.black),
          ],
        ),
      ),
    );
  }
}
