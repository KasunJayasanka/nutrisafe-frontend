import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/features/home/widgets/quick_stat_card.dart';
import 'package:frontend_v2/features/home/data/dashboard_models.dart';

class QuickStatsCarousel extends StatefulWidget {
  final Progress progress; // <- use the full Progress object from /goals-by-date

  const QuickStatsCarousel({super.key, required this.progress});

  @override
  State<QuickStatsCarousel> createState() => _QuickStatsCarouselState();
}

class _QuickStatsCarouselState extends State<QuickStatsCarousel> {
  late final PageController _pc;

  @override
  void initState() {
    super.initState();
    _pc = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.progress;

    // Build a list of cards to render
    final items = <_CardData>[
      _CardData(
        title: 'Calories',
        value: p.calories.consumed,
        target: p.calories.goal,
        unit: 'kcal',
        icon: Icons.local_fire_department,
        iconBg: AppColors.emerald500,
        gradient: const [AppColors.emerald50, AppColors.emerald100],
        extra: 'Remaining: ${(p.calories.goal - p.calories.consumed).clamp(0, double.infinity).toStringAsFixed(0)} kcal',
      ),
      _CardData(
        title: 'Protein',
        value: p.protein.consumed,
        target: p.protein.goal,
        unit: 'g',
        icon: Icons.fitness_center,
        iconBg: AppColors.sky500,
        gradient: const [AppColors.sky50, AppColors.sky100],
      ),
      _CardData(
        title: 'Carbs',
        value: p.carbs.consumed,
        target: p.carbs.goal,
        unit: 'g',
        icon: Icons.rice_bowl,
        iconBg: AppColors.amber600,
        gradient: const [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
      ),
      _CardData(
        title: 'Fat',
        value: p.fat.consumed,
        target: p.fat.goal,
        unit: 'g',
        icon: Icons.oil_barrel_outlined,
        iconBg: AppColors.rose500,
        gradient: const [Color(0xFFFFF1F2), Color(0xFFFFE4E6)],
      ),
      _CardData(
        title: 'Sodium',
        value: p.sodium.consumed,
        target: p.sodium.goal,
        unit: 'mg',
        icon: Icons.snowing, // pick any icon you like
        iconBg: AppColors.violet500,
        gradient: const [Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
      ),
      _CardData(
        title: 'Sugar',
        value: p.sugar.consumed,
        target: p.sugar.goal,
        unit: 'g',
        icon: Icons.cake_outlined,
        iconBg: AppColors.pink500,
        gradient: const [Color(0xFFFDF2F8), Color(0xFFFCE7F3)],
      ),
      _CardData(
        title: 'Hydration',
        value: p.hydration.consumed,
        target: p.hydration.goal,
        unit: 'glasses',
        icon: Icons.water_drop,
        iconBg: AppColors.sky500,
        gradient: const [AppColors.sky50, AppColors.sky100],
      ),
      _CardData(
        title: 'Exercise',
        value: p.exercise.consumed,
        target: p.exercise.goal,
        unit: 'min',
        icon: Icons.directions_run,
        iconBg: AppColors.emerald500,
        gradient: const [AppColors.emerald50, AppColors.emerald100],
      ),
    ];

    return SizedBox(
      height: 152, // enough to show the card nicely
      child: PageView.builder(
        controller: _pc,
        itemCount: items.length,
        padEnds: false,
        itemBuilder: (context, index) {
          final it = items[index];

          // Use your existing QuickStatCard for visual consistency
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: 8,
            ),
            child: QuickStatCard(
              icon: it.icon,
              iconBackground: it.iconBg,
              title: it.title,
              value: it.value.toStringAsFixed(
                it.value % 1 == 0 ? 0 : 1, // 0 decimals for ints, 1 for floats
              ),
              unitLabel: it.unit,
              target: it.target.round(),
              extraLine: it.extra,
              colors: it.gradient,
            ),
          );
        },
      ),
    );
  }
}

class _CardData {
  final String title;
  final double value;
  final double target;
  final String unit;
  final IconData icon;
  final Color iconBg;
  final List<Color> gradient;
  final String? extra;

  _CardData({
    required this.title,
    required this.value,
    required this.target,
    required this.unit,
    required this.icon,
    required this.iconBg,
    required this.gradient,
    this.extra,
  });
}
