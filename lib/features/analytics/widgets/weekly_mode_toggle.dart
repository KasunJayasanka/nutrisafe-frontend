import 'package:flutter/material.dart';
import '../data/analytics_models.dart';
import '../../../core/theme/app_colors.dart';

class WeeklyModeToggle extends StatelessWidget {
  final WeeklyMode mode;
  final VoidCallback onChart;
  final VoidCallback onDetailed;

  const WeeklyModeToggle({super.key, required this.mode, required this.onChart, required this.onDetailed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _btn(icon: Icons.bar_chart, label: 'Chart', active: mode==WeeklyMode.chart, onTap: onChart),
        const SizedBox(width: 8),
        _btn(icon: Icons.visibility, label: 'Detailed', active: mode==WeeklyMode.detailed, onTap: onDetailed),
      ],
    );
  }

  Widget _btn({required IconData icon, required String label, required bool active, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.emerald600 : Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Icon(icon, size: 16, color: active ? Colors.white : Colors.black87),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: active ? Colors.white : Colors.black87)),
        ]),
      ),
    );
  }
}
