import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/features/profile/data/bmi_result.dart';

class BmiCard extends StatelessWidget {
  final BmiResult result;
  const BmiCard({super.key, required this.result});

  Color _badgeColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'underweight':
        return const Color(0xFF38BDF8); // sky-400
      case 'normal weight':
        return const Color(0xFF10B981); // emerald-500
      case 'overweight':
        return const Color(0xFFF59E0B); // amber-500
      default:
        return const Color(0xFFEF4444); // red-500 for obesity classes
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _badgeColor(result.category);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [AppColors.emerald50, AppColors.sky50],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.emerald200),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Left: Big number
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.emerald200),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('BMI',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      )),
                  Text(
                    result.bmi.toStringAsFixed(2),
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Right: details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      const Text('Category:',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.black)),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: c.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: c),
                        ),
                        child: Text(result.category,
                            style: TextStyle(
                                color: c, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Based on ${result.heightCm.toStringAsFixed(0)} cm and '
                        '${result.weightKg.toStringAsFixed(1)} kg'
                        '${result.usedOverride ? " (temporary values)" : ""}.',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Normal range is 18.5–24.9 for adults.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
