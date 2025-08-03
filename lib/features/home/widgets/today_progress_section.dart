import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';


class ProgressRow extends StatelessWidget {
  final String label;
  final double consumed;
  final double target;
  final Color color;

  const ProgressRow({
    Key? key,
    required this.label,
    required this.consumed,
    required this.target,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // percent is 0.0 – 1.0
    final percentage = (consumed / target).clamp(0.0, 1.0);
    final percentText = (percentage * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // ─── Label Row ─────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // “Calories” (or “Protein”, etc.), in dark text:
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary, // a dark‐gray, not pure black
                ),
              ),
              // “76%” (in the same color as the filled bar)
              Text(
                '$percentText%',
                style: TextStyle(
                  fontSize: 14,
                  color: color, // e.g. emerald600 or sky600
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // ─── Progress Bar ──────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200, // light gray “track”
              valueColor: AlwaysStoppedAnimation<Color>(
                color, // the “fill” color
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TodayProgressSection extends StatelessWidget {
  final int caloriesConsumed;
  final int caloriesTarget;
  final int proteinConsumed;
  final int proteinTarget;
  final int waterConsumed;
  final int waterTarget;

  const TodayProgressSection({
    Key? key,
    required this.caloriesConsumed,
    required this.caloriesTarget,
    required this.proteinConsumed,
    required this.proteinTarget,
    required this.waterConsumed,
    required this.waterTarget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // force the card to be white
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header Row (“Today's Progress”) ───────────────
            ListTile(
              leading: const Icon(Icons.trending_up,
                  color: AppColors.emerald600),
              title: const Text(
                "Today's Progress",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            // ─── Three Progress Bars ───────────────────────────
            ProgressRow(
              label: 'Calories',
              consumed: caloriesConsumed.toDouble(),
              target: caloriesTarget.toDouble(),
              color: AppColors.black,
            ),
            ProgressRow(
              label: 'Protein',
              consumed: proteinConsumed.toDouble(),
              target: proteinTarget.toDouble(),
              color: AppColors.black,
            ),
            ProgressRow(
              label: 'Hydration',
              consumed: waterConsumed.toDouble(),
              target: waterTarget.toDouble(),
              color: AppColors.black,
            ),
          ],
        ),
      ),
    );
  }
}
