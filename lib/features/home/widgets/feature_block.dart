
import 'package:flutter/material.dart';
import '/../../core/theme/app_colors.dart';

class FeatureBlock extends StatelessWidget {
  final String emoji;

  final String label;

  const FeatureBlock({
    Key? key,
    required this.emoji,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.white20,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10, // text-xs
            color: AppColors.white80,
          ),
        ),
      ],
    );
  }
}
