// File: lib/features/home/widgets/nutrient_breakdown_card.dart
import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class NutrientBreakdownCard extends StatelessWidget {
  final Map<String, int> protein; // { consumed, target }
  final Map<String, int> carbs;   // { consumed, target }
  final Map<String, int> fats;    // { consumed, target }
  final List<Map<String, dynamic>> micronutrients;

  const NutrientBreakdownCard({
    Key? key,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.micronutrients,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors that resemble the screenshot
    const barColor = Color(0xFF0B1220); // deep slate / ink
    final pillBg   = const Color(0xFFF1F5F9); // slate-100
    final railBg   = Colors.grey.shade200;

    return DefaultTabController(
      length: 2,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: const [
                  Icon(Icons.apple, color: AppColors.orange600),
                  SizedBox(width: 8),
                  Text(
                    'Nutrient Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Segmented tabs (Macros / Micros)
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)), // slate-200
                ),
                child: TabBar(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: EdgeInsets.zero,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: pillBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: 'Macros'),
                    Tab(text: 'Micros'),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Content
              SizedBox(
                height: 220,
                child: TabBarView(
                  children: [
                    _MacrosTab(
                      barColor: barColor,
                      railBg: railBg,
                      protein: protein,
                      carbs: carbs,
                      fats: fats,
                    ),
                    _MicrosTab(
                      barColor: barColor,
                      railBg: railBg,
                      micronutrients: micronutrients,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MacrosTab extends StatelessWidget {
  final Map<String, int> protein;
  final Map<String, int> carbs;
  final Map<String, int> fats;
  final Color barColor;
  final Color railBg;

  const _MacrosTab({
    Key? key,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.barColor,
    required this.railBg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget row({
      required String label,
      required double consumed,
      required double target,
      required String unit,
    }) {
      final pct = target == 0 ? 0.0 : (consumed / target).clamp(0.0, 1.0);
      String d(double v) => v.toStringAsFixed(0); // whole numbers like UI

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label + value on right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  )),
              Text('${d(consumed)}$unit / ${d(target)}$unit',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                  )),
            ],
          ),
          const SizedBox(height: 6),
          // progress + percent (percent sits to the right in Micros only in screenshot,
          // but keeping consistent layout feels good)
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: railBg,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          row(
            label: 'Protein',
            consumed: (protein['consumed'] ?? 0).toDouble(),
            target: (protein['target'] ?? 0).toDouble(),
            unit: 'g',
          ),
          const SizedBox(height: 12),
          row(
            label: 'Carbohydrates',
            consumed: (carbs['consumed'] ?? 0).toDouble(),
            target: (carbs['target'] ?? 0).toDouble(),
            unit: 'g',
          ),
          const SizedBox(height: 12),
          row(
            label: 'Fats',
            consumed: (fats['consumed'] ?? 0).toDouble(),
            target: (fats['target'] ?? 0).toDouble(),
            unit: 'g',
          ),
        ],
      ),
    );
  }
}

class _MicrosTab extends StatelessWidget {
  final List<Map<String, dynamic>> micronutrients;
  final Color barColor;
  final Color railBg;

  const _MicrosTab({
    Key? key,
    required this.micronutrients,
    required this.barColor,
    required this.railBg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String d(double v) => v.toStringAsFixed(0);

    Widget row({
      required String label,
      required double consumed,
      required double target,
      required String unit,
    }) {
      final pct = target == 0 ? 0.0 : (consumed / target).clamp(0.0, 1.0);

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: label + meter
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // label + “x / y”
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        )),
                    Text(
                      '${d(consumed)}$unit / ${d(target)}$unit',
                      style: const TextStyle(fontSize: 13, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 8,
                    backgroundColor: railBg,
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Right: % bold
          Text(
            '${(pct * 100).toStringAsFixed(0)}%',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: ListView.separated(
        itemCount: micronutrients.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final n = micronutrients[i];
          final consumed = (n['consumed'] as num?)?.toDouble() ?? 0.0;
          final target   = (n['target']   as num?)?.toDouble() ?? 0.0;
          final unit     = (n['unit'] as String?) ?? '';
          final label    = (n['name'] as String?) ?? '—';

          return row(
            label: label,
            consumed: consumed,
            target: target,
            unit: unit,
          );
        },
      ),
    );
  }
}
