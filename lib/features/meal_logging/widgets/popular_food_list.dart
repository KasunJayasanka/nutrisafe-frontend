// lib/features/meal_logging/widgets/popular_food_list.dart

import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class PopularFood {
  final String name;
  final int calories;
  final int protein;
  final bool safe;

  const PopularFood({
    required this.name,
    required this.calories,
    required this.protein,
    required this.safe,
  });
}

class PopularFoodList extends StatelessWidget {
  const PopularFoodList({Key? key}) : super(key: key);

  static const List<PopularFood> popularFoods = [
    PopularFood(name: 'Chicken Breast', calories: 165, protein: 31, safe: true),
    PopularFood(name: 'Brown Rice',    calories: 216, protein: 5,  safe: true),
    PopularFood(name: 'Greek Yogurt',  calories: 150, protein: 20, safe: true),
    PopularFood(name: 'Avocado',       calories: 234, protein: 3,  safe: true),
    PopularFood(name: 'Quinoa',        calories: 222, protein: 8,  safe: true),
    PopularFood(name: 'Salmon',        calories: 208, protein: 22, safe: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Foods',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...popularFoods.map((food) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.food_bank, color: AppColors.primary),
            title: Text(
              food.name,
              style: TextStyle(color: AppColors.textPrimary),
            ),
            subtitle: Text(
              '${food.calories} cal • ${food.protein}g protein',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (food.safe)
                  Chip(
                    label: const Text('Safe'),
                    backgroundColor: AppColors.emerald100,
                    labelStyle:
                    const TextStyle(color: AppColors.emerald600),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: AppColors.emerald600,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Added ${food.name} to your log!')),
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
