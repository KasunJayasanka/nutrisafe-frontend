import 'package:flutter/material.dart';
import 'number_input_field_sm.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'progress_row.dart';

class GoalsSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final bool isEditing;
  final String unitLabel; // e.g., "kcal", "g", "glasses", "min"
  final int targetValue;
  final double currentValue;
  final void Function(int)? onTargetChanged;

  const GoalsSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.isEditing,
    required this.unitLabel,
    required this.targetValue,
    required this.currentValue,
    this.onTargetChanged,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentValue / targetValue).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.emerald400,
            AppColors.sky400
          ],
        ),
      ),
      child: Card(
        color: Colors.white.withOpacity(0.85), // keeps text readable over gradient
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Row
              Row(
                children: [
                  Icon(icon, color: iconColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Target Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Target', style: Theme.of(context).textTheme.bodyMedium),
                  isEditing
                      ? NumberInputFieldSm(
                    value: targetValue,
                    onChanged: (v) => onTargetChanged?.call(v),
                    suffix: unitLabel,
                    highlight: true,
                  )
                      : Text(
                    '$targetValue $unitLabel',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Progress
              ProgressRow(
                label: title,
                current: currentValue,
                goal: targetValue.toDouble(),
              ),

              const SizedBox(height: 4),

              // Percentage
              // Percentage
              Text(
                '${(progress * 100).toStringAsFixed(2)}% Complete', // ⬅ two decimals now
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: progress < 0.33
                      ? Colors.red
                      : progress < 0.66
                      ? Colors.orange
                      : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
