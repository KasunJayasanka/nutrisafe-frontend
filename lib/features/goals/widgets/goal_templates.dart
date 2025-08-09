import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'gradient_border_section.dart';

class GoalTemplates extends StatelessWidget {
  final void Function(String templateKey) onApply;
  const GoalTemplates({super.key, required this.onApply});

  @override
  Widget build(BuildContext context) {
    Widget template(String title, String subtitle, String key) {
      return SizedBox(
        width: double.infinity, // ⬅️ make the button fill the row
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(12),
            side: const BorderSide(color: Color(0xFFCBD5E1)),
            foregroundColor: AppColors.textPrimary,
            backgroundColor: Colors.white.withOpacity(0.70),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            minimumSize: const Size(double.infinity, 48), // ⬅️ ensure full width + good height
          ),
          onPressed: () => onApply(key),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity, // ⬅️ make the whole section full width
      child: GradientBorderSection(
        child: Container(
          width: double.infinity, // ⬅️ keep inner container full width
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.emerald400.withOpacity(0.10),
                AppColors.sky400.withOpacity(0.10),
                AppColors.indigo500.withOpacity(0.10),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Goal Templates', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              template('Weight Loss', 'Moderate calorie deficit', 'weight_loss'),
              const SizedBox(height: 8),
              template('Muscle Gain', 'High protein, calorie surplus', 'muscle_gain'),
              const SizedBox(height: 8),
              template('Maintenance', 'Balanced nutrition', 'maintenance'),
            ]),
          ),
        ),
      ),
    );
  }
}
