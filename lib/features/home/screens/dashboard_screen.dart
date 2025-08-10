import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:frontend_v2/core/widgets/top_bar.dart';
import 'package:frontend_v2/core/widgets/bottom_nav_bar.dart';

import 'package:frontend_v2/features/home/widgets/quick_stats_grid.dart';
import 'package:frontend_v2/features/home/widgets/today_progress_section.dart';
import 'package:frontend_v2/features/home/widgets/nutrient_breakdown_card.dart';
import 'package:frontend_v2/features/home/widgets/alerts_section.dart';
import 'package:frontend_v2/features/home/widgets/recent_meals_section.dart';

import 'package:frontend_v2/features/home/provider/home_provider.dart';

class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    useEffect(() {
      // Delay to let build finish
      Future.microtask(() => ref.invalidate(dashboardProvider));
      return null;
    }, const []);

    final state = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: TopBar(onBellTap: () {}),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFFECFDF5), Color(0xFFF0F9FF), Color(0xFFEEF2FF)],
          ),
        ),
        child: SafeArea(
          child: state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Failed to load dashboard: $e')),
            data: (data) {
              // pull what the widgets need
              final g = data.goals;
              final p = data.goals.progress;
              final macros = data.breakdown.macros;
              final micros = data.breakdown.micros;

              final caloriesConsumed = p.calories.consumed.round();
              final caloriesTarget   = g.goals.calories.round(); // not used here; see below
              final hydrationConsumed = p.hydration.consumed.round();
              final hydrationTarget   = g.goals.hydration.round();

              final proteinConsumed = p.protein.consumed.round();
              final proteinTarget   = g.goals.protein.round();

              // QuickStats at the top → Calories + Hydration (requested change)
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    QuickStatsGrid(
                      caloriesConsumed: caloriesConsumed,
                      caloriesTarget: g.goals.calories.toInt(),
                      // swap protein with hydration at the top:
                      hydrationConsumed: hydrationConsumed,  // <- hydration
                      hydrationTarget: hydrationTarget,       // <- hydration target
                    ),
                    const SizedBox(height: 20),

                    // Today’s progress (keep calories + protein + hydration bars)
                    TodayProgressSection(
                      caloriesConsumed: caloriesConsumed,
                      caloriesTarget: g.goals.calories.toInt(),
                      proteinConsumed: proteinConsumed,
                      proteinTarget: proteinTarget,
                      waterConsumed: hydrationConsumed,
                      waterTarget: hydrationTarget,
                    ),

                    const SizedBox(height: 20),

                    // Nutrient breakdown card from API (macros + micros)
                    NutrientBreakdownCard(
                      protein: {
                        'consumed': (macros['protein']?.consumed ?? 0).round(),
                        'target':   (macros['protein']?.goal ?? g.goals.protein).round(),
                      },
                      carbs: {
                        'consumed': (macros['carbs']?.consumed ?? 0).round(),
                        'target':   (macros['carbs']?.goal ?? g.goals.carbs).round(),
                      },
                      fats: {
                        'consumed': (macros['fat']?.consumed ?? 0).round(),
                        'target':   (macros['fat']?.goal ?? g.goals.fat).round(),
                      },
                      micronutrients: [
                        // Use what you return; zeros are fine per your note
                        {'name': 'Sodium',  'consumed': micros['sodium']?.consumed ?? 0, 'target': micros['sodium']?.goal ?? g.goals.sodium, 'unit': micros['sodium']?.unit ?? 'mg'},
                        {'name': 'Sugar',   'consumed': micros['sugar']?.consumed ?? 0,  'target': micros['sugar']?.goal ?? g.goals.sugar,   'unit': micros['sugar']?.unit ?? 'g'},
                        {'name': 'Calcium', 'consumed': micros['calcium']?.consumed ?? 0, 'target': micros['calcium']?.goal ?? 0, 'unit': micros['calcium']?.unit ?? 'mg'},
                        {'name': 'Iron',    'consumed': micros['iron']?.consumed ?? 0,    'target': micros['iron']?.goal ?? 0,    'unit': micros['iron']?.unit ?? 'mg'},
                        {'name': 'Vitamin A','consumed': micros['vitaminA']?.consumed ?? 0,'target': micros['vitaminA']?.goal ?? 0,'unit': micros['vitaminA']?.unit ?? 'µg'},
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Alerts — you can replace this later with a real endpoint
                    const AlertsSection(alerts: []),

                    const SizedBox(height: 20),

                    // Recent meals card (flat list)
                    RecentMealsSection(
                      recentLogs: data.recentItems.map((e) => {
                        'time': _relativeTime(e.ateAt),
                        'food': e.foodLabel,
                        'calories': e.calories.round(),
                        'safety': e.safe ? 'safe' : 'warn',
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (idx) {
          switch (idx) {
            case 1: Navigator.pushReplacementNamed(context, '/food'); break;
            case 2: Navigator.pushReplacementNamed(context, '/goals'); break;
            case 4:
              if (ModalRoute.of(context)?.settings.name != '/profile') {
                Navigator.pushReplacementNamed(context, '/profile');
              }
              break;
          }
        },
      ),
    );
  }

  String _relativeTime(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours   < 24) return '${diff.inHours} hours ago';
    return DateFormat('MMM d, h:mm a').format(t);
  }
}
