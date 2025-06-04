import 'package:flutter/material.dart';
import '/../../core/theme/app_colors.dart';

class ProgressSection extends StatelessWidget {
  /// Progress value from 0 to 100
  final int progress;

  final String statusText;

  const ProgressSection({
    Key? key,
    required this.progress,
    required this.statusText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Outer container width = 256 px (Tailwind’s w-64)
    const double barTotalWidth = 256;

    return Column(
      children: [
        Container(
          width: barTotalWidth,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.white20,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              // Animated “filled” portion
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: barTotalWidth * (progress / 100),
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.white, // plain white
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          statusText,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.white80,
          ),
        ),
      ],
    );
  }
}
