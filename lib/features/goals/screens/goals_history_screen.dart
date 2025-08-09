// File: lib/features/goals/screens/goals_history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/goals_provider.dart';
import '../widgets/history_day_card.dart';
import '../widgets/goals_by_date_sheet.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/core/widgets/gradient_app_bar.dart';

enum HistoryFilter { last7, last30, all }

class GoalsHistoryScreen extends HookConsumerWidget {
  const GoalsHistoryScreen({super.key});

  String _yyyyMmDd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(dailyProgressListProvider);
    final filter = useState(HistoryFilter.last7);

    List<T> _applyFilter<T>(
        List<T> items,
        HistoryFilter f,
        DateTime Function(T) getDate,
        ) {
      if (f == HistoryFilter.all) return items;
      final now = DateTime.now();
      final start = f == HistoryFilter.last7
          ? now.subtract(const Duration(days: 7))
          : now.subtract(const Duration(days: 30));
      return items.where((x) => getDate(x).isAfter(start)).toList();
    }

    return Scaffold(
      // ✅ Match Goals screen AppBar
      appBar: const GradientAppBar(
        title: 'Goals History',
        centerTitle: false,
      ),

      // ✅ Soft gradient background like Goals screen
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [AppColors.emerald50, AppColors.sky50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: asyncList.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (items) {
              // Newest first
              items.sort((a, b) => b.date.compareTo(a.date));
              final filtered = _applyFilter(items, filter.value, (x) => x.date);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ✅ Elevated “highlighted” filter row
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFCBD5E1)), // slate-300
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Icon(Icons.filter_alt_rounded, color: AppColors.emerald600, size: 20),
                        _Chip(
                          label: 'Last 7',
                          selected: filter.value == HistoryFilter.last7,
                          onTap: () => filter.value = HistoryFilter.last7,
                        ),
                        _Chip(
                          label: 'Last 30',
                          selected: filter.value == HistoryFilter.last30,
                          onTap: () => filter.value = HistoryFilter.last30,
                        ),
                        _Chip(
                          label: 'All',
                          selected: filter.value == HistoryFilter.all,
                          onTap: () => filter.value = HistoryFilter.all,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: filtered.isEmpty
                        ? const Center(child: Text('No history yet'))
                        : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, i) {
                        final item = filtered[i];
                        final dateKey = _yyyyMmDd(item.date);
                        return HistoryDayCard(
                          item: item,
                          onOpen: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              backgroundColor: Colors.white,      // ✅ white sheet base
                              shape: const RoundedRectangleBorder( // nice top radius
                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                              builder: (_) => GoalsByDateSheet(yyyyMmDd: dateKey),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// Small helper chip with “selected” emphasis
class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.emerald100,
      backgroundColor: Colors.white,
      labelStyle: const TextStyle(color: AppColors.textPrimary),
      side: BorderSide(
        color: selected ? AppColors.emerald400 : const Color(0xFFCBD5E1),
      ),
    );
  }
}
