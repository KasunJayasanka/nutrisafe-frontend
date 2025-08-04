// lib/features/meal_logging/widgets/food_list_item.dart

import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import '../data/food_model.dart';

class FoodListItem extends StatelessWidget {
  final Food food;
  final VoidCallback? onAdd;

  const FoodListItem({
    Key? key,
    required this.food,
    this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // little spacing between items
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          food.label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          food.category,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          color: AppColors.emerald600,
          onPressed: onAdd,
        ),
      ),
    );
  }
}
