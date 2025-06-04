import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/features/auth/widgets/gradient_button.dart';

class ForgotSuccessStep extends StatelessWidget {
  final VoidCallback onFinish;

  const ForgotSuccessStep({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.check_circle,
              size: 48,
              color: Colors.green,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Password Reset Successfully!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'You can now sign in with your new password.',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        GradientButton(
          text: 'Back to Login',
          isLoading: false,
          onPressed: onFinish,
        ),
      ],
    );
  }
}
