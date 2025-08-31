import 'package:flutter/material.dart';
import '/../../core/theme/app_colors.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Nutrivue',
          style: TextStyle(
            fontSize: 40, // ~text-5xl
            fontWeight: FontWeight.bold,
            color: AppColors.white, // plain white
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Smart Nutrition Management',
          style: TextStyle(
            fontSize: 20, // text-xl
            fontWeight: FontWeight.w500,
            color: AppColors.white90,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Track your nutrition, analyze food safety, and achieve your diet goals',
          style: TextStyle(
            fontSize: 14, // text-sm
            color: AppColors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
