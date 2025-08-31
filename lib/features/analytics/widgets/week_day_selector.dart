import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class WeekDaySelector extends StatelessWidget {
  final DateTime weekStart; // Monday
  final ValueChanged<DateTime> onPickWeekStart;
  final VoidCallback onPickDate; // opens date picker
  final String viewMode; // 'chart' or 'detailed'
  final ValueChanged<String> onChangeMode;

  const WeekDaySelector({
    super.key,
    required this.weekStart,
    required this.onPickWeekStart,
    required this.onPickDate,
    required this.viewMode,
    required this.onChangeMode,
  });

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (i) => weekStart.add(Duration(days: i)));
    final labels = const ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Mode toggle
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'chart', label: Text('Chart'), icon: Icon(Icons.bar_chart)),
            ButtonSegment(value: 'detailed', label: Text('Detailed'), icon: Icon(Icons.visibility)),
          ],
          selected: {viewMode},
          onSelectionChanged: (s) => onChangeMode(s.first),
        ),
        FilledButton.tonal(
          onPressed: onPickDate,
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.calendar_month, size: 18),
            SizedBox(width: 6),
            Text('Pick a date'),
          ]),
        ),
        const SizedBox(width: 8),
        // Inline weekday chips
        for (int i = 0; i < 7; i++)
          ChoiceChip(
            selected: false,
            label: Text(labels[i]),
            onSelected: (_) => onPickWeekStart(days[i].subtract(Duration(days: days[i].weekday - 1))),
            selectedColor: AppColors.emerald100,
          ),
      ],
    );
  }
}
