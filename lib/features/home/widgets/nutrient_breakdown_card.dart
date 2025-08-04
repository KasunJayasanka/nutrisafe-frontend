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
    return DefaultTabController(
      length: 2,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            // ─── Header + Icon ───────────────────────────────
            ListTile(
              leading: const Icon(Icons.apple, color: AppColors.orange600),
              title: const Text(
                'Nutrient Breakdown',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Title in black
                ),
              ),
            ),

            // ─── Tabs: “Macros” / “Micros” ────────────────────
            TabBar(
              labelColor: Colors.black, // selected tab label in black
              unselectedLabelColor: AppColors.textSecondary, // existing gray
              indicatorColor: Colors.black, // black underline for the active tab
              tabs: const [
                Tab(text: 'Macros'),
                Tab(text: 'Micros'),
              ],
            ),

            // ─── Tab Views ────────────────────────────────────
            SizedBox(
              height: 200, // adjust as needed
              child: TabBarView(
                children: [
                  _MacrosTab(
                    protein: protein,
                    carbs: carbs,
                    fats: fats,
                  ),
                  _MicrosTab(micronutrients: micronutrients),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacrosTab extends StatelessWidget {
  final Map<String, int> protein;
  final Map<String, int> carbs;
  final Map<String, int> fats;

  const _MacrosTab({
    Key? key,
    required this.protein,
    required this.carbs,
    required this.fats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget singleMacroRow({
      required String label,
      required double consumed,
      required double target,
      required String unit,
    }) {
      final pct = (consumed / target).clamp(0.0, 1.0);
      final pctText = (pct * 100).round();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Label + “XX%” in black ───────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Text(
                '${consumed.toInt()}$unit / ${target.toInt()}$unit ($pctText%)',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // ─── Black Progress Bar ───────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              color: Colors.black, // fill color set to black
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          singleMacroRow(
            label: 'Protein',
            consumed: protein['consumed']!.toDouble(),
            target: protein['target']!.toDouble(),
            unit: 'g',
          ),
          const SizedBox(height: 8),
          singleMacroRow(
            label: 'Carbohydrates',
            consumed: carbs['consumed']!.toDouble(),
            target: carbs['target']!.toDouble(),
            unit: 'g',
          ),
          const SizedBox(height: 8),
          singleMacroRow(
            label: 'Fats',
            consumed: fats['consumed']!.toDouble(),
            target: fats['target']!.toDouble(),
            unit: 'g',
          ),
        ],
      ),
    );
  }
}

class _MicrosTab extends StatelessWidget {
  final List<Map<String, dynamic>> micronutrients;

  const _MicrosTab({
    Key? key,
    required this.micronutrients,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget singleMicroRow({
      required String label,
      required double consumed,
      required double target,
      required String unit,
    }) {
      final pct = (consumed / target).clamp(0.0, 1.0);
      final pctText = (pct * 100).round();
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ─── Left side (label + “XX / YY unit”) ───────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${consumed.toInt()}$unit / ${target.toInt()}$unit',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                // ─── Black Progress Bar ────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.black, // fill color set to black
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),
          // ─── “XX%” on the right in bold black ──────────
          Text(
            '$pctText%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView.separated(
        itemCount: micronutrients.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, idx) {
          final n = micronutrients[idx];
          final consumed = (n['consumed'] as int).toDouble();
          final target = (n['target'] as int).toDouble();
          final unit = n['unit'] as String;
          final label = n['name'] as String;
          return singleMicroRow(
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
