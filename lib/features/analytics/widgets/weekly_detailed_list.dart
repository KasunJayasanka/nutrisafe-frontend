// lib/features/analytics/widgets/weekly_detailed_list.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../data/analytics_models.dart';

class WeeklyDetailedList extends StatelessWidget {
  final List<WeeklyDayDetailed> days;
  final DateTime selectedDate; // <-- NEW

  const WeeklyDetailedList({
    super.key,
    required this.days,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final key = DateFormat('yyyy-MM-dd').format(selectedDate);
    final match = days.where((d) => d.date == key).toList();

    if (match.isEmpty) {
      // Friendly empty state for the chosen day
      final pretty = DateFormat('y-MM-dd (EEE)').format(selectedDate);
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'No data for $pretty',
                style: const TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      );
    }

    // exactly one card for the selected day
    return _dayCard(match.first);
  }

  Widget _dayCard(WeeklyDayDetailed d) {
    Widget progressRow(String label, Metric m, {Color? color}) {
      color ??= AppColors.orange600;
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
                const Spacer(),
                Text(
                  '${m.actual.toStringAsFixed(2)} / ${m.target.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: (m.percent / 100).clamp(0, 1),
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color!),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${m.percent.toStringAsFixed(1)}% Complete',
                style: TextStyle(fontSize: 11, color: color),
              ),
            ),
          ],
        ),
      );
    }

    final m = d.metrics;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFFE0F2FE), Color(0xFFECFEFF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(color: Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(d.date, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          progressRow('Calories',        m['calories']!,        color: AppColors.orange600),
          progressRow('Protein',         m['protein_g']!,       color: AppColors.sky600),
          progressRow('Carbohydrates',   m['carbs_g']!,         color: Colors.green),
          progressRow('Fat',             m['fat_g']!,           color: Colors.amber),
          progressRow('Sodium',          m['sodium_mg']!,       color: AppColors.purple600),
          progressRow('Sugar',           m['sugar_g']!,         color: AppColors.pink600),
          progressRow('Hydration',       m['hydration']!,       color: AppColors.teal600),
          progressRow('Exercise',        m['exercise_minute']!, color: AppColors.blue600),
        ],
      ),
    );
  }
}
