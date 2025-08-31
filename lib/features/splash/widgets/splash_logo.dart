import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main logo container with rounded corners & semi-transparent background
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.white20,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.white30, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.favorite,
              size: 48,
              color: AppColors.white,
            ),
          ),
        ),

        // Small star/shine effect at the top right
        Positioned(
          top: -4,
          right: -4,
          child: Icon(
            Icons.auto_awesome,
            size: 24,
            color: AppColors.yellow300,
          ),
        ),
      ],
    );
  }
}
