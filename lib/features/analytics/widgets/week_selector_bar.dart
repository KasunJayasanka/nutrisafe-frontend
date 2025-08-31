// lib/features/analytics/widgets/week_selector_bar.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';

class WeekSelectorBar extends StatelessWidget {
  final DateTime weekMonday;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelectDay;
  final Future<void> Function() onPickDate;

  const WeekSelectorBar({
    super.key,
    required this.weekMonday,
    required this.selectedDate,
    required this.onSelectDay,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (i) => DateTime(
      weekMonday.year, weekMonday.month, weekMonday.day + i,
    ));
    final fmt = DateFormat('EEE'); // Mon, Tue, Wed...

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.backgroundGradientStart, // emerald50
            AppColors.backgroundGradientEnd,   // sky50
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          // Segmented day buttons
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _SegmentedGroup<DateTime>(
                    values: days,
                    isSelected: days.map((d) => _sameDay(d, selectedDate)).toList(),
                    labelBuilder: (d) => fmt.format(d), // Mon / Tue / ...
                    onPressed: (idx) => onSelectDay(days[idx]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: onPickDate,
            icon: const Icon(Icons.calendar_month, size: 18, color: AppColors.emerald600),
            label: const Text('Pick a date'),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.sky100),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Small helper that renders a ToggleButtons group with rounded pills.
class _SegmentedGroup<T> extends StatelessWidget {
  final List<T> values;
  final List<bool> isSelected;
  final String Function(T value) labelBuilder;
  final void Function(int index) onPressed;

  const _SegmentedGroup({
    required this.values,
    required this.isSelected,
    required this.labelBuilder,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: isSelected,
      onPressed: onPressed,
      renderBorder: true,
      borderRadius: BorderRadius.circular(20),
      borderColor: Colors.black26,
      selectedBorderColor: AppColors.sky100,
      fillColor: AppColors.sky100,
      selectedColor: AppColors.emerald600,
      color: Colors.black87,
      constraints: const BoxConstraints(minWidth: 56, minHeight: 36),
      children: values
          .map((v) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          labelBuilder(v),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ))
          .toList(),
    );
  }
}
