// lib/features/analytics/screens/analytics_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/widgets/gradient_app_bar.dart';
import '../../../core/widgets/top_bar.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/theme/app_colors.dart';

import '../../goals/screens/goals_history_screen.dart';
import '../providers/analytics_provider.dart';
import '../data/analytics_models.dart';
import '../widgets/monthly_summary_card.dart';
import '../widgets/week_controls.dart';
import '../widgets/weekly_mode_toggle.dart';
import '../widgets/week_selector_bar.dart';
import '../widgets/weekly_chart_card.dart';
import '../widgets/weekly_detailed_list.dart';

class AnalyticsScreen extends HookConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analyticsOverviewProvider);
    final notifier = ref.read(analyticsOverviewProvider.notifier);

    useEffect(() {
      notifier.load();
      return null;
    }, const []);

    final selectedDate = ref.watch(selectedOverviewDateProvider);
    final weeklyMode = ref.watch(weeklyModeProvider);
    final weekMonday = _mondayOf(selectedDate);

    return Scaffold(
      backgroundColor: AppColors.background,

      // TopBar has only `onBellTap`
      appBar: GradientAppBar(
        title: 'Your Analytics',
      ),

      // BottomNavBar requires `onTap`; index for Analytics is 3
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        onTap: (idx) {
          // Adjust these route names to your app’s navigation
          switch (idx) {
            case 0:
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/food');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/goals');
              break;
            case 3:
            // already on Analytics
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),

      body: RefreshIndicator(
        onRefresh: () => notifier.load(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (state.loading) const LinearProgressIndicator(minHeight: 2),
              const SizedBox(height: 8),

              // Monthly Summary
              if (state.summary != null)
                MonthlySummaryCard(data: state.summary!),

              const SizedBox(height: 12),

              // Header + Controls
              Card(
                color: AppColors.cardBackground,
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Colors.black12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + toggle + week controls in one Wrap row
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.stacked_bar_chart, size: 18, color: Colors.grey),
                              SizedBox(width: 6),
                              Text('Weekly Overview', style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),

                          WeeklyModeToggle(
                            mode: weeklyMode,
                            onChart: () => notifier.changeWeeklyMode(WeeklyMode.chart),
                            onDetailed: () => notifier.changeWeeklyMode(WeeklyMode.detailed),
                          ),

                          // The week controls (Mon–Sun chips + prev/next + pick week)
                          SizedBox(
                            width: double.infinity, // allow it to wrap nicely in small screens
                            child: WeekControls(
                              weekMonday: weekMonday,
                              selectedDate: selectedDate,
                              onChangeWeek: (monday) => notifier.changeDate(monday),
                              onSelectDay: (d) => notifier.changeDate(d),
                              isDetailedView: weeklyMode == WeeklyMode.detailed, // 👈 here
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // (Weekly chart or detailed list comes after)
                    ],
                  ),
                ),
              ),


              const SizedBox(height: 10),

              // Weekly content
              if (state.weekly != null &&
                  state.weekly!.mode == WeeklyMode.chart &&
                  state.weekly!.chartDays != null)
                WeeklyChartCard(days: state.weekly!.chartDays!),

              if (state.weekly != null &&
                  state.weekly!.mode == WeeklyMode.detailed &&
                  state.weekly!.detailedDays != null)
                WeeklyDetailedList(
                  days: state.weekly!.detailedDays!,
                  selectedDate: selectedDate, // <-- pass the chosen day
                ),

              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(state.error!, style: const TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime _mondayOf(DateTime d) {
    final wd = d.weekday; // Mon=1..Sun=7
    return DateTime(d.year, d.month, d.day).subtract(Duration(days: wd - 1));
  }
}
