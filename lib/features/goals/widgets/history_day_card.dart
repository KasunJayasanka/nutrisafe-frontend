// File: lib/features/goals/widgets/history_day_card.dart

import 'package:flutter/material.dart';
import '../data/daily_progress_model.dart';
import 'progress_row.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class HistoryDayCard extends StatelessWidget {
  final DailyProgressItem item;
  final VoidCallback onOpen;
  const HistoryDayCard({super.key, required this.item, required this.onOpen});

  String _prettyDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = _prettyDate(item.date);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.white.withOpacity(0.92),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE5E7EB)), // light border
      ),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                const Icon(Icons.event, size: 20, color: AppColors.emerald600),
                const SizedBox(width: 8),
                Text(
                  dateLabel,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                // quick badges for hydration/exercise
                _pill(icon: Icons.opacity, text: item.hydration.toStringAsFixed(2)),
                const SizedBox(width: 8),
                _pill(icon: Icons.directions_run, text: '${item.exercise.toStringAsFixed(2)}m'),
              ],
            ),
            const SizedBox(height: 12),

            // Calories summary with 2 decimals
            Text('Calories', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),

            // ProgressRow shows numbers with 2 decimals (see optional tweak below)
            ProgressRow(label: 'Calories', current: item.calories, goal: 1),
            const SizedBox(height: 6),

            // Quick compact macros with 2 decimals
            Row(
              children: [
                Expanded(
                  child: _miniBar(
                    context,
                    title: 'Protein',
                    valueLabel: '${item.protein.toStringAsFixed(2)} g',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _miniBar(
                    context,
                    title: 'Carbs',
                    valueLabel: '${item.carbs.toStringAsFixed(2)} g',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'View details',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: AppColors.sky600, fontWeight: FontWeight.w600),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _pill({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.sky50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFDBFE)), // sky-200
      ),
      child: Row(children: [
        Icon(icon, size: 14, color: AppColors.sky600),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _miniBar(BuildContext context, {required String title, required String valueLabel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: const LinearProgressIndicator(
            value: 0.0, // compact visual only; detailed % comes from the bottom sheet
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 2),
        Text(valueLabel, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
