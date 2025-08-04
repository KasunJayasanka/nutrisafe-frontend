// lib/features/meal_logging/screens/food_logger_screen.dart

import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/camera_card.dart';
import '../widgets/manual_search_card.dart';
import '../widgets/todays_meal_list.dart';
import 'package:frontend_v2/core/widgets/bottom_nav_bar.dart';

class FoodLoggerScreen extends ConsumerStatefulWidget {
  const FoodLoggerScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<FoodLoggerScreen> createState() =>
      _FoodLoggerScreenState();
}

class _FoodLoggerScreenState extends ConsumerState<FoodLoggerScreen> {
  int _navIndex = 1;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(children: [
            const SizedBox(height: 16),
            // Tab pill
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.emerald50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(4),
                  labelColor: AppColors.textPrimary,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                  unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                  tabs: const [
                    Tab(child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Add Food'),
                    )),
                    Tab(child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("Today's Meals"),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(children: const [
                    CameraCard(),
                    SizedBox(height: 24),
                    ManualSearchCard(),
                  ]),
                ),
                const TodaysMealList(),
              ]),
            )
          ]),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _navIndex,
          onTap: (idx) {
            if (idx == _navIndex) return;
            switch (idx) {
              case 0:
                Navigator.pushReplacementNamed(context, '/dashboard');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/goals');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/analytics');
                break;
              case 4:
                Navigator.pushReplacementNamed(context, '/profile');
                break;
            }
            setState(() => _navIndex = idx);
          },
        ),
      ),
    );
  }
}
