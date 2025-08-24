// lib/features/meal_logging/widgets/todays_meal_list.dart

import 'package:flutter/material.dart';
import 'package:frontend_v2/features/meal_logging/widgets/meal_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../provider/meal_provider.dart';
import '../screens/edit_meal_screen.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref, int mealId) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white, // force white background
      title: const Text(
        'Delete meal?',
        style: TextStyle(color: Colors.black), // ensure title text is black
      ),
      content: const Text(
        'This will permanently remove this meal and its items.',
        style: TextStyle(color: Colors.black87),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );

  if (shouldDelete == true) {
    await ref.read(mealProvider).deleteMeal(mealId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal deleted')),
      );
    }
  }
}


class TodaysMealList extends ConsumerWidget {

  const TodaysMealList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prov = ref.watch(mealProvider);
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

            return MealCard(
              meal: m,
              timeLabel: time,
              totalCalories: totalCal,
              isSafe: safe,
              prov: prov,
              ref: ref,
            );
          },
        ),
      ),
    );
  }
}
