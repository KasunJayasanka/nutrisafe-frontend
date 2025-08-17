// lib/features/analytics/widgets/week_controls.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';

class WeekControls extends StatelessWidget {
  final DateTime weekMonday;                // normalized to Monday
  final DateTime selectedDate;              // current day selection
  final ValueChanged<DateTime> onChangeWeek; // -> new Monday
  final ValueChanged<DateTime> onSelectDay;  // -> picked day
  final bool isDetailedView;                // show day row only in detailed

  const WeekControls({
    super.key,
    required this.weekMonday,
    required this.selectedDate,
    required this.onChangeWeek,
    required this.onSelectDay,
    required this.isDetailedView,
  });

  @override
  Widget build(BuildContext context) {
    final days = List.generate(
      7,
          (i) => DateTime(weekMonday.year, weekMonday.month, weekMonday.day + i),
    );
    final dFmt = DateFormat('EEE'); // Mon, Tue…

    return Column(
      children: [
        // —— top bar: gradient capsule + chevrons + week pill ——————
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.backgroundGradientStart, // emerald50
                AppColors.backgroundGradientEnd,   // sky50
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              _chev(
                Icons.chevron_left,
                    () => onChangeWeek(weekMonday.subtract(const Duration(days: 7))),
              ),

              // week “pill” in the middle (keeps the old style)
              Expanded(
                child: Center(
                  child: _WeekPill(
                    label: _rangeLabel(weekMonday),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialDate: selectedDate,
                        helpText: 'Pick a week (any date)',
                      );
                      if (picked != null) {
                        onChangeWeek(_mondayOf(picked));
                      }
                    },
                  ),
                ),
              ),

              _chev(
                Icons.chevron_right,
                    () => onChangeWeek(weekMonday.add(const Duration(days: 7))),
              ),
            ],
          ),
        ),

        // —— day row (only for detailed) ————————————————
        if (isDetailedView) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: List.generate(days.length, (i) {
                final d = days[i];
                final selected = _sameDay(d, selectedDate);
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextButton(
                      onPressed: () => onSelectDay(d),
                      style: TextButton.styleFrom(
                        backgroundColor: selected ? AppColors.sky100 : Colors.white,
                        foregroundColor: selected ? AppColors.emerald600 : AppColors.textPrimary,
                        side: const BorderSide(color: Colors.black26),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        dFmt.format(d),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ],
    );
  }

  // ——— helpers ———
  static Widget _chev(IconData icon, VoidCallback onTap) => IconButton(
    icon: Icon(icon, color: AppColors.emerald600, size: 24),
    onPressed: onTap,
    splashRadius: 22,
  );

  static String _rangeLabel(DateTime monday) {
    final start = DateFormat('MMM d').format(monday);
    final end = DateFormat('MMM d').format(monday.add(const Duration(days: 6)));
    return '$start – $end';
  }

  static DateTime _mondayOf(DateTime d) =>
      DateTime(d.year, d.month, d.day).subtract(Duration(days: d.weekday - 1));

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

// the centered pill keeping the old “Pick a date” look
class _WeekPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _WeekPill({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.sky100),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_month, size: 18, color: AppColors.emerald600),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
