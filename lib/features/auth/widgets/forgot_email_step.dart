import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/features/auth/widgets/custom_text_form_field.dart';
import 'package:frontend_v2/features/auth/widgets/gradient_button.dart';

class ForgotEmailStep extends StatelessWidget {
  final TextEditingController emailController;
  final bool isLoading;
  final VoidCallback onSubmit;

  const ForgotEmailStep({
    super.key,
    required this.emailController,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter your email address and we’ll send you a 6-digit code '
              'to reset your password.',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          label: 'Email Address',
          controller: emailController,
          hintText: 'your@example.com',
          prefixIcon: Icons.mail,
          keyboardType: TextInputType.emailAddress,
          enabled: !isLoading,
        ),
        const SizedBox(height: 24),
        GradientButton(
          text: isLoading ? 'Sending Code…' : 'Send Reset Code',
          isLoading: isLoading,
          onPressed: onSubmit,
        ),
      ],
    );
  }
}
