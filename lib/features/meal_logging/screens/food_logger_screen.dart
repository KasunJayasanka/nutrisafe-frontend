// lib/features/meal_logging/screens/food_logger_screen.dart

import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/camera_card.dart';
import '../widgets/manual_search_card.dart';
import '../widgets/todays_meal_list.dart';
import 'package:frontend_v2/core/widgets/bottom_nav_bar.dart';
import 'package:frontend_v2/features/meal_logging/screens/meal_history_screen.dart'
    show MealHistoryContent;

class FoodLoggerScreen extends ConsumerStatefulWidget {
  const FoodLoggerScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<FoodLoggerScreen> createState() =>
      _FoodLoggerScreenState();
}

class _FoodLoggerScreenState extends ConsumerState<FoodLoggerScreen>
    with TickerProviderStateMixin {
  int _navIndex = 1;
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // ⬅️ remove DefaultTabController
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.emerald50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabs,
                  indicator: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(4),
                  labelColor: AppColors.textPrimary,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  tabs: const [
                    Tab(child: Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Add Food'))),
                    Tab(child: Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text("Today's Meals"))),
                    Tab(child: Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('History'))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: const [
                  _KeepAlive(child: _AddFoodTab()),
                  _KeepAlive(child: TodaysMealList()),
                  _KeepAlive(child: MealHistoryContent()),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _navIndex,
        onTap: (idx) {
          if (idx == _navIndex) return;
          // avoid setState after route replacement
          switch (idx) {
            case 0: Navigator.pushReplacementNamed(context, '/dashboard'); return;
            case 2: Navigator.pushReplacementNamed(context, '/goals'); return;
            case 3: Navigator.pushReplacementNamed(context, '/analytics'); return;
            case 4: Navigator.pushReplacementNamed(context, '/profile'); return;
          }
          if (mounted) setState(() => _navIndex = idx);
        },
      ),
    );
  }
}

// Optional: small wrapper so tabs don't dispose on switch
class _KeepAlive extends StatefulWidget {
  final Widget child;
  const _KeepAlive({required this.child});
  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}
class _KeepAliveState extends State<_KeepAlive> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) { super.build(context); return widget.child; }
}

// Extracted for clarity (same content you had before)
class _AddFoodTab extends StatelessWidget {
  const _AddFoodTab();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: const [CameraCard(), SizedBox(height: 24), ManualSearchCard()]),
    );
  }
}

