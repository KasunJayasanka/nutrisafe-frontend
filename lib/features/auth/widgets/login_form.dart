import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'custom_text_form_field.dart';
import 'gradient_button.dart';
import 'package:frontend_v2/features/auth/screens/forgot_password_screen.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool showPassword;
  final VoidCallback toggleShowPassword;
  final bool isLoading;
  final Future<void> Function() onSubmit;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.showPassword,
    required this.toggleShowPassword,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Email Field ───────────────────────────────────
        CustomTextFormField(
          label: 'Email',
          controller: emailController,
          hintText: 'user@example.com',
          prefixIcon: Icons.mail,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),

        // ─── Password Field ────────────────────────────────
        CustomTextFormField(
          label: 'Password',
          controller: passwordController,
          hintText: '..........',
          isPassword: true,
          showPassword: showPassword,
          toggleShowPassword: toggleShowPassword,
          prefixIcon: Icons.lock,
        ),
        const SizedBox(height: 24),

        // ─── Sign In Button ────────────────────────────────
        GradientButton(
          text: isLoading ? 'Signing in…' : 'Sign In',
          isLoading: isLoading,
          onPressed: () async => await onSubmit(),
        ),

        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ForgotPasswordScreen(
                    // When “Back” is tapped inside ForgotPasswordScreen, pop back to login:
                    onBack: () => Navigator.of(context).pop(),
                  ),
                ),
              );
            },
            child: Text(
              'Forgot password?',
              style: TextStyle(
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
