import 'package:flutter/material.dart';
import '/../../core/theme/app_colors.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Semi‐transparent container with heart icon
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.white20,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.white30, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25), // unchanged
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],

          ),
          child: const Center(
            child: Icon(
              Icons.favorite,
              size: 48, // w-12 h-12
              color: AppColors.white, // plain white
            ),
          ),
        ),

        Positioned(
          top: -4,
          right: -4,
          child: Icon(
            Icons.auto_awesome,
            size: 24, // w-6 h-6
            color: AppColors.yellow300,
          ),
        ),
      ],
    );
  }
}
