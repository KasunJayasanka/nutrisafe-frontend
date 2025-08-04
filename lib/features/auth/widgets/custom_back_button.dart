import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class CustomBackButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomBackButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        backgroundColor: AppColors.cardBackground,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      child: Text(label),
    );
  }
}
