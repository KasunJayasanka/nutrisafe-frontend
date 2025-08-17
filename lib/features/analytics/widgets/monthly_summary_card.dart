// lib/features/analytics/widgets/monthly_summary_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../data/analytics_models.dart';
import '../providers/analytics_provider.dart';

class MonthlySummaryCard extends HookConsumerWidget {
  final AnalyticsSummary data;
  const MonthlySummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(analyticsOverviewProvider.notifier);
    final selectedDate = ref.watch(selectedOverviewDateProvider);
    final monthLabel = DateFormat('MMMM yyyy').format(selectedDate);

    // Build a flat list of tiles from macros + micros + other
    final tiles = <_TileSpec>[
      // --- Macros ---
      ..._toTiles(
        labelPrefix: 'Avg',
        items: data.macros,
        colors: const [
          AppColors.emerald50,
          AppColors.sky50,
          Color(0xFFEDE9FE),
          Color(0xFFF3E8FF),
        ],
      ),

      // --- Micros ---
      ..._toTiles(
        labelPrefix: 'Avg',
        items: data.micros,
        colors: const [
          Color(0xFFFFF7ED),
          Color(0xFFFFF1F2),
          Color(0xFFEFF6FF),
        ],
      ),

      // --- Other (hydration, exercise) ---
      ..._toTiles(
        labelPrefix: 'Avg',
        items: data.other,
        colors: const [
          Color(0xFFEFFDF5),
          Color(0xFFE0F2F1),
          Color(0xFFE3F2FD),
        ],
      ),

      // --- Extra KPI tiles ---
      _TileSpec(
        bg: const Color(0xFFEDE9FE),
        title: 'Days Counted',
        value: '${data.metadata.daysCounted}',
        accent: const Color(0xFF6B21A8),
      ),
      _TileSpec(
        bg: const Color(0xFFFFF7ED),
        title: 'Safety Score',
        value: '${data.safety.scorePct.toStringAsFixed(0)}%',
        accent: const Color(0xFF92400E),
      ),
      _TileSpec(
        bg: const Color(0xFFEFF6FF),
        title: 'Items Logged',
        value: '${data.safety.totalItems ?? 0}',
        accent: const Color(0xFF1E40AF),
      ),
    ];

    return Card(
      color: AppColors.cardBackground,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header WITH month picker controls
            Row(
              children: const [
                Icon(Icons.insights, color: AppColors.emerald600, size: 20),
                SizedBox(width: 8),
                Text(
                  "Monthly Overview",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    color: AppColors.emerald600, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020, 1, 1),
                        lastDate: DateTime(now.year, now.month, now.day),
                      );
                      if (picked != null) {
                        // snap to 1st of picked month
                        await notifier.changeMonth(DateTime(picked.year, picked.month, 1));
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          monthLabel,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_drop_down, size: 20, color: Colors.black54),
                      ],
                    ),
                  ),
                ),
                // Range text (left aligned; small)
                Text(
                  '${data.range.from} → ${data.range.to}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 6),
                // Prev / Next chevrons
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  tooltip: 'Previous month',
                  onPressed: () => notifier.prevMonth(),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  tooltip: 'Next month',
                  onPressed: () => notifier.nextMonth(),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tiles.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 78,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, i) => _MetricTile(spec: tiles[i]),
            ),

            // Optional: safety breakdown chips (no “only logged days” flag)
            if ((data.safety.safeItems ?? 0) > 0 ||
                (data.safety.unsafeItems ?? 0) > 0 ||
                (data.safety.unknownItems ?? 0) > 0)
              const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                if (data.safety.safeItems != null)
                  _chip('Safe: ${data.safety.safeItems}'),
                if (data.safety.unsafeItems != null)
                  _chip('Unsafe: ${data.safety.unsafeItems}'),
                if (data.safety.unknownItems != null)
                  _chip('Unknown: ${data.safety.unknownItems}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helpers --------------------------------------------------------------

  static List<_TileSpec> _toTiles({
    required String labelPrefix, // e.g., "Avg"
    required Map<String, NutrAvg> items,
    required List<Color> colors,
  }) {
    final keys = items.keys.toList()..sort(); // stable order
    return List.generate(keys.length, (i) {
      final key = keys[i];
      final v = items[key]!;
      final prettyTitle = _prettyKey(key);
      final color = colors[i % colors.length];
      final value = _formatAvg(v);

      return _TileSpec(
        bg: color,
        title: '$labelPrefix $prettyTitle',
        value: value,
        accent: _accentFor(color),
      );
    });
  }

  static String _formatAvg(NutrAvg v) {
    final n = v.avgConsumed;
    final u = v.unit?.trim();
    if (u == null || u.isEmpty) return n.toStringAsFixed(0);
    if (u == 'kcal') return n.toStringAsFixed(0);
    if (u == 'g')    return '${n.toStringAsFixed(0)}g';
    if (u == 'mg')   return '${n.toStringAsFixed(0)}mg';
    return '${n.toStringAsFixed(0)} $u';
  }

  static String _prettyKey(String k) {
    switch (k.toLowerCase()) {
      case 'carbs': return 'Carbs';
      case 'protein': return 'Protein';
      case 'fat': return 'Fat';
      case 'calories': return 'Calories';
      case 'sodium': return 'Sodium';
      case 'sugar': return 'Sugar';
      case 'hydration': return 'Hydration';
      case 'exercise': return 'Exercise';
      default:
        if (k.isEmpty) return k;
        return k[0].toUpperCase() + k.substring(1);
    }
  }

  static Color _accentFor(Color bg) {
    if (bg == AppColors.emerald50) return const Color(0xFF065F46);
    if (bg == AppColors.sky50) return const Color(0xFF075985);
    if (bg.value == const Color(0xFFF3E8FF).value) return const Color(0xFF6B21A8);
    if (bg.value == const Color(0xFFFFF7ED).value) return const Color(0xFF92400E);
    if (bg.value == const Color(0xFFEFF6FF).value) return const Color(0xFF1E40AF);
    return Colors.black87;
  }

  static Widget _chip(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.emerald100,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(fontSize: 12, color: Color(0xFF065F46)),
    ),
  );
}

// Tile Spec + Widget ------------------------------------------------------

class _TileSpec {
  final Color bg;
  final String title;
  final String value;
  final Color accent;

  _TileSpec({
    required this.bg,
    required this.title,
    required this.value,
    required this.accent,
  });
}

class _MetricTile extends StatelessWidget {
  final _TileSpec spec;
  const _MetricTile({required this.spec});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: spec.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            spec.value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: spec.accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            spec.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
