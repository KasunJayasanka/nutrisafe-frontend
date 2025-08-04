// lib/features/meal_logging/widgets/todays_meal_list.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../provider/meal_provider.dart';
import '../screens/edit_meal_screen.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class TodaysMealList extends ConsumerWidget {
  const TodaysMealList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meals = ref.watch(mealProvider).todayMeals;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.backgroundGradientStart,
            AppColors.backgroundGradientEnd,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: meals.isEmpty
            ? Center(
          child: Text(
            'No meals today.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          itemCount: meals.length,
          itemBuilder: (ctx, i) {
            final m = meals[i];
            final ateAtLocal = m.ateAt.toLocal();
            final time =
            TimeOfDay.fromDateTime(ateAtLocal).format(ctx);
            final totalCal = m.items
                .fold<double>(0, (sum, it) => sum + it.calories);
            final safe = m.items.every((it) => it.safe);

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header Row ─────────────────────────
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.emerald50,
                          child: const Icon(
                            Icons.restaurant,
                            color: AppColors.emerald600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.type,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                time,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── Calories + Safe Chip ───────────────
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${totalCal.toStringAsFixed(0)} cal',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: safe
                                    ? AppColors.emerald50
                                    : AppColors.orange600
                                    .withOpacity(0.2),
                                borderRadius:
                                BorderRadius.circular(6),
                              ),
                              child: Text(
                                safe ? 'Safe' : '⚠ Unsafe',
                                style: TextStyle(
                                  color: safe
                                      ? AppColors.emerald600
                                      : AppColors.orange600,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 8),

                        // ── Rounded “Edit” Pill ─────────────────
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(ctx).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditMealScreen(mealId: m.id),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          label: Text(
                            'Edit',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: AppColors.textSecondary),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            visualDensity:
                            VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 8),

                    // ── Item Lines ─────────────────────────
                    ...m.items.map((it) {
                      final unit = it.measureUri
                          .split('#')
                          .last
                          .split('_')
                          .last
                          .toLowerCase();
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text('• ',
                                style: TextStyle(
                                    color:
                                    AppColors.textPrimary)),
                            Expanded(
                              child: Text(
                                '${it.foodLabel} '
                                    '(${it.quantity.toStringAsFixed(0)} '
                                    '$unit)',
                                style: TextStyle(
                                  color:
                                  AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
