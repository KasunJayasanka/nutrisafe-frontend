import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/analytics_models.dart';

class WeeklyChartCard extends StatelessWidget {
  final List<WeeklyDayChart> days;
  const WeeklyChartCard({super.key, required this.days});

  static const _seriesOrder = <String>[
    'calories', 'protein', 'carbohydrates', 'fat', 'sodium', 'sugar', 'hydration', 'exercise',
  ];

  static const _seriesColors = <String, Color>{
    'calories':      AppColors.orange600,
    'protein':       AppColors.sky600,
    'carbohydrates': Colors.green,
    'fat':           Colors.amber,
    'sodium':        AppColors.purple600,
    'sugar':         AppColors.pink600,
    'hydration':     AppColors.teal600,
    'exercise':      AppColors.blue600,
  };

  @override
  Widget build(BuildContext context) {
    // Compute a stable, readable Y max (snap to 20s; cap to 160)
    final rawMax = days.expand((d) => d.percentages.values).fold<double>(0, (m, v) => v > m ? v : m);
    double _snap20(double v) => (v / 20.0).ceil() * 20.0;
    final maxY = (_snap20(rawMax <= 100 ? 110 : rawMax + 10)).clamp(100, 160).toDouble();

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE0F2FE), Color(0xFFECFEFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Compact title row (prevents overflow)
              Row(
                children: const [
                  Icon(Icons.bar_chart, size: 16, color: Colors.black54),
                  SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Weekly Nutrition (percent of goal)',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Compact 2-row legend (no scrolling, no overflow)
              _LegendGrid(seriesOrder: _seriesOrder, seriesColors: _seriesColors),

              const SizedBox(height: 8),

              // Plot surface
              Container(
                clipBehavior: Clip.hardEdge, // <-- stop overpainting
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black12),
                ),
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: SizedBox(
                  height: 260, // a bit shorter to avoid layout pressure
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Responsive bar sizing
                      const rodSpace = 2.0;
                      const groupSpace = 18.0;
                      final innerWidth = constraints.maxWidth - 20; // borders/padding
                      final rodsPerGroup = _seriesOrder.length;
                      final totalFixed = (rodsPerGroup - 1) * rodSpace + groupSpace;
                      final estRodWidth = ((innerWidth / days.length) - totalFixed) / rodsPerGroup;
                      final rodWidth = estRodWidth.clamp(5.0, 9.0);

                      final groups = List.generate(days.length, (i) {
                        final p = days[i].percentages;
                        final rods = _seriesOrder.map((k) {
                          final v = (p[k] ?? 0).toDouble();
                          return BarChartRodData(
                            toY: v,
                            width: rodWidth,
                            borderRadius: BorderRadius.circular(3),
                            color: _seriesColors[k],
                          );
                        }).toList();

                        return BarChartGroupData(x: i, barsSpace: rodSpace, barRods: rods);
                      });

                      return BarChart(
                        BarChartData(
                          minY: 0,
                          maxY: maxY,
                          groupsSpace: groupSpace,
                          barGroups: groups,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 20,
                            getDrawingHorizontalLine: (v) => FlLine(
                              color: Colors.black12,
                              strokeWidth: 1,
                              dashArray: const [5, 6],
                            ),
                          ),
                          // 100% reference line
                          extraLinesData: ExtraLinesData(horizontalLines: [
                            HorizontalLine(
                              y: 100,
                              color: AppColors.emerald600.withOpacity(0.35),
                              strokeWidth: 2,
                              dashArray: const [8, 6],
                              label: HorizontalLineLabel(
                                show: true,
                                alignment: Alignment.topRight,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                                labelResolver: (_) => '100%',
                              ),
                            ),
                          ]),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.black26, width: 1),
                          ),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(
                              axisNameWidget: const Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Text('Percent (%)',
                                    style: TextStyle(fontSize: 11, color: Colors.black54)),
                              ),
                              axisNameSize: 14,
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40, // more room → no crowding
                                interval: 20,
                                getTitlesWidget: (v, _) => Text(
                                  v.toInt().toString(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 22,
                                getTitlesWidget: (value, meta) {
                                  const w = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                  final i = value.toInt();
                                  if (i < 0 || i >= days.length) return const SizedBox.shrink();
                                  final d = DateTime.parse(days[i].date);
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(w[d.weekday - 1], style: const TextStyle(fontSize: 10)),
                                  );
                                },
                              ),
                            ),
                          ),
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              tooltipBorderRadius: BorderRadius.circular(8),
                              tooltipPadding:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              getTooltipItem: (group, gIdx, rod, rIdx) {
                                final series = _seriesOrder[rIdx];
                                final iso = days[gIdx].date;
                                final d = DateTime.parse(iso);
                                const w = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                return BarTooltipItem(
                                  '${w[d.weekday - 1]}  •  $iso\n'
                                      '${_labelFor(series)}: ${rod.toY.toStringAsFixed(1)}%',
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        swapAnimationDuration: const Duration(milliseconds: 350),
                        swapAnimationCurve: Curves.easeOut,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _labelFor(String key) {
    switch (key) {
      case 'calories': return 'Calories';
      case 'protein': return 'Protein';
      case 'carbohydrates': return 'Carbohydrates';
      case 'fat': return 'Fat';
      case 'sodium': return 'Sodium';
      case 'sugar': return 'Sugar';
      case 'hydration': return 'Hydration';
      case 'exercise': return 'Exercise';
      default: return key;
    }
  }
}

/// Compact, fixed 2-row legend – no scroll, no overflow
class _LegendGrid extends StatelessWidget {
  final List<String> seriesOrder;
  final Map<String, Color> seriesColors;

  const _LegendGrid({
    required this.seriesOrder,
    required this.seriesColors,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: seriesOrder.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,          // 4 × 2 = 8 chips
        mainAxisExtent: 28,         // slimmer → avoids overflow
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (_, i) {
        final key = seriesOrder[i];
        final color = seriesColors[key]!;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  _label(key),
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static String _label(String key) => WeeklyChartCard._labelFor(key);
}
