import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/features/auth/widgets/custom_text_form_field.dart';
import 'package:frontend_v2/features/auth/widgets/gradient_button.dart';

class ForgotVerifyStep extends StatelessWidget {
  final TextEditingController codeController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool showPassword;
  final bool showConfirmPassword;
  final bool isLoading;
  final VoidCallback toggleShowPassword;
  final VoidCallback toggleShowConfirmPassword;
  final VoidCallback onSubmit;
  final VoidCallback onBackToEmail;
  final String emailAddress;

  const ForgotVerifyStep({
    super.key,
    required this.codeController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.showPassword,
    required this.showConfirmPassword,
    required this.isLoading,
    required this.toggleShowPassword,
    required this.toggleShowConfirmPassword,
    required this.onSubmit,
    required this.onBackToEmail,
    required this.emailAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter the 6-digit code sent to $emailAddress and choose a new password.',
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // ─── Verification Code ─────────────────────────────
        const Text(
          'Verification Code',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: codeController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: InputDecoration(
            hintText: '123456',
            hintStyle: TextStyle(color: Colors.grey.shade600),
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
            ),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          ),
          enabled: !isLoading,
        ),

        const SizedBox(height: 16),

        // ─── New Password ───────────────────────────────────
        CustomTextFormField(
          label: 'New Password',
          controller: newPasswordController,
          hintText: 'At least 8 characters',
          isPassword: true,
          showPassword: showPassword,
          toggleShowPassword: toggleShowPassword,
          prefixIcon: Icons.lock,
          enabled: !isLoading,
        ),

        const SizedBox(height: 16),

        // ─── Confirm New Password ───────────────────────────
        CustomTextFormField(
          label: 'Confirm New Password',
          controller: confirmPasswordController,
          hintText: 'Re-enter new password',
          isPassword: true,
          showPassword: showConfirmPassword,
          toggleShowPassword: toggleShowConfirmPassword,
          prefixIcon: Icons.lock,
          enabled: !isLoading,
        ),

        const SizedBox(height: 24),
        GradientButton(
          text: isLoading ? 'Resetting Password…' : 'Reset Password',
          isLoading: isLoading,
          onPressed: onSubmit,
        ),

        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: isLoading ? null : onBackToEmail,
            child: const Text(
              "Didn't receive the code? Go back",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.emerald400,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
