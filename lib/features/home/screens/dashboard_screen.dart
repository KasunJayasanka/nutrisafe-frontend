import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/core/widgets/top_bar.dart';
import 'package:frontend_v2/core/widgets/bottom_nav_bar.dart';

import 'package:frontend_v2/features/home/widgets/quick_stats_grid.dart';
import 'package:frontend_v2/features/home/widgets/today_progress_section.dart';
import 'package:frontend_v2/features/home/widgets/nutrient_breakdown_card.dart';
import 'package:frontend_v2/features/home/widgets/alerts_section.dart';
import 'package:frontend_v2/features/home/widgets/recent_meals_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // keep track of bottom bar selection:
  int _currentIndex = 0;

  // ───────────────────────
  // Mock data (hard‐coded demo values)
  final Map<String, Map<String, int>> _todayStats = {
    'calories': {'consumed': 1680, 'target': 2200},
    'protein': {'consumed': 85,   'target': 120},
    'water': {'consumed': 6,      'target': 8},   // cups or liters
    'exercise': {'consumed': 45,  'target': 60},  // minutes
  };

  final Map<String, Map<String, int>> _macronutrients = {
    'carbs': {'consumed': 190, 'target': 250},
    'fats':  {'consumed': 55,  'target': 70},
  };

  final List<Map<String, dynamic>> _micronutrients = [
    {'name': 'Iron',      'consumed': 12,   'target': 18,   'unit': 'mg'},
    {'name': 'Calcium',   'consumed': 900,  'target': 1000, 'unit': 'mg'},
    {'name': 'Potassium', 'consumed': 3100, 'target': 3500, 'unit': 'mg'},
    {'name': 'Vitamin D', 'consumed': 15,   'target': 20,   'unit': 'mcg'},
    {'name': 'Magnesium', 'consumed': 280,  'target': 400,  'unit': 'mg'},
  ];

  final List<Map<String, String>> _alerts = [
    {'type': 'warning', 'message': 'Low protein intake today', 'time': '1h ago'},
    {'type': 'info',    'message': 'Great hydration progress!',   'time': '3h ago'},
  ];

  final List<Map<String, dynamic>> _recentLogs = [
    {'time': '2 hours ago', 'food': 'Grilled Chicken Salad',   'calories': 420, 'safety': 'safe'},
    {'time': '4 hours ago', 'food': 'Greek Yogurt',            'calories': 150, 'safety': 'safe'},
    {'time': '6 hours ago', 'food': 'Oatmeal with Berries',     'calories': 280, 'safety': 'safe'},
  ];
  // ───────────────────────

  @override
  Widget build(BuildContext context) {
    final caloriesConsumed = _todayStats['calories']!['consumed']!;
    final caloriesTarget   = _todayStats['calories']!['target']!;
    final proteinConsumed  = _todayStats['protein']!['consumed']!;
    final proteinTarget    = _todayStats['protein']!['target']!;
    final waterConsumed    = _todayStats['water']!['consumed']!;
    final waterTarget      = _todayStats['water']!['target']!;

    return Scaffold(
      // ─── TopBar ───────────────────────────
      appBar: TopBar(onBellTap: () {
        // handle bell tap if needed
      }),

      // ─── Body (scrollable) ─────────────────
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFECFDF5), // emerald-50
              Color(0xFFF0F9FF), // sky-50
              Color(0xFFEEF2FF), // indigo-100
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // 1) Quick Stats (Calories + Protein)  ─────
                QuickStatsGrid(
                  caloriesConsumed: caloriesConsumed,
                  caloriesTarget: caloriesTarget,
                  proteinConsumed: proteinConsumed,
                  proteinTarget: proteinTarget,
                ),

                const SizedBox(height: 20),

                // 2) Today’s Progress ───────────────────────
                TodayProgressSection(
                  caloriesConsumed: caloriesConsumed,
                  caloriesTarget: caloriesTarget,
                  proteinConsumed: proteinConsumed,
                  proteinTarget: proteinTarget,
                  waterConsumed: waterConsumed,
                  waterTarget: waterTarget,
                ),

                const SizedBox(height: 20),

                // 3) Nutrient Breakdown (Macros / Micros) ───
                NutrientBreakdownCard(
                  protein: _todayStats['protein']!,
                  carbs: _macronutrients['carbs']!,
                  fats: _macronutrients['fats']!,
                  micronutrients: _micronutrients,
                ),

                const SizedBox(height: 20),

                // 4) Alerts & Recommendations ───────────────
                AlertsSection(alerts: _alerts),

                const SizedBox(height: 20),

                // 5) Recent Meals ───────────────────────────
                RecentMealsSection(recentLogs: _recentLogs),
              ],
            ),
          ),
        ),
      ),

      // ─── Bottom Navigation Bar ─────────────────
      bottomNavigationBar: BottomNavBar(
        // “Dashboard” is the first destination (index 0)
        currentIndex: 0,
        onTap: (idx) {
          switch (idx) {
            case 0:
            // Already on Dashboard, do nothing
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/food');
              break;
            case 4:
            // If user taps “Profile” (index 4), navigate there
              if (ModalRoute.of(context)?.settings.name != '/profile') {
                Navigator.pushReplacementNamed(context, '/profile');
              }
              break;
          // If you eventually add “Food”, “Goals”, “Analytics” screens, handle them here:
          //

          // case 2:
          //   Navigator.pushReplacementNamed(context, '/goals');
          //   break;
          // case 3:
          //   Navigator.pushReplacementNamed(context, '/analytics');
          //   break;
          }
        },
      ),
    );
  }
}
