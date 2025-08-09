import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class ProgressRow extends StatelessWidget {
  final String label;
  final double current;
  final double goal;

  const ProgressRow({
    super.key,
    required this.label,
    required this.current,
    required this.goal,
  });

  Color _colorForPct(double pct, BuildContext ctx) {
    if (pct >= 0.8) return Colors.green.shade600;
    if (pct >= 0.6) return Colors.amber.shade700;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    final double pct = goal == 0 ? 0 : (current / goal).clamp(0, 1).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${current.toStringAsFixed(2)} / ${goal.toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            Text(
              '${(pct * 100).toStringAsFixed(2)}%',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: _colorForPct(pct, context)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 8,
            backgroundColor: AppColors.emerald400,
            valueColor:
            AlwaysStoppedAnimation<Color>(AppColors.emerald700),
          ),
        ),
      ],
    );
  }
}
