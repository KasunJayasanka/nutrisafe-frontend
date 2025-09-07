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
      width: double.infinity,
      child: GradientBorderSection(
        child: Container(
          width: double.infinity,
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
            // 🔹 Make content scrollable
            child: SizedBox(
              // pick a height that looks good in your layout:
              height: 320, // or MediaQuery.of(context).size.height * 0.4
              child: Scrollbar(
                thumbVisibility: false,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Text('Goal Templates', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      '*AMDR: Acceptable Macronutrient Distribution Range',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // your template buttons
                    template('DGA – Maintenance (U.S.-Style)',
                        'AMDR-balanced; keeps <10% kcal from added sugars; ≤2300 mg sodium',
                        'dga_maint'),
                    const SizedBox(height: 8),
                    template('DGA – Weight Loss (Moderate)',
                        '≈15% kcal deficit; protein tilt within AMDR', 'dga_cut'),
                    const SizedBox(height: 8),
                    template('DGA – Muscle Gain (Moderate)',
                        '≈10% kcal surplus; within AMDR', 'dga_gain'),
                    const SizedBox(height: 8),
                    template('DGA – Mediterranean-Style',
                        'Higher healthy fat within AMDR; same DGA limits', 'dga_med'),
                    const SizedBox(height: 8),
                    template('DGA – Vegetarian-Style',
                        'Higher carbs within AMDR; same DGA limits', 'dga_veg'),
                    const SizedBox(height: 8),
                    template('DGA – Pregnancy (Trimester 2)',
                        '+340 kcal; within AMDR', 'dga_preg_t2'),
                    const SizedBox(height: 8),
                    template('DGA – Pregnancy (Trimester 3)',
                        '+452 kcal; within AMDR', 'dga_preg_t3'),
                    const SizedBox(height: 8),
                    template('DGA – Lactation (0–6 mo)',
                        '+330 kcal; within AMDR', 'dga_lac_1'),
                    const SizedBox(height: 8),
                    template('DGA – Lactation (7–12 mo)',
                        '+400 kcal; within AMDR', 'dga_lac_2'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }
}
