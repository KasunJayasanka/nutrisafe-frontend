import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'custom_text_form_field.dart';
import 'gradient_button.dart';

class RegisterForm extends StatelessWidget {
  // final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool showPassword;
  final VoidCallback toggleShowPassword;
  final bool isLoading;
  final Future<void> Function() onSubmit;

  const RegisterForm({
    super.key,
    // required this.nameController,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
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
        // ─── Full Name ─────────────────────────────────────
        CustomTextFormField(
          label: 'First Name',
          controller: firstNameController,
          hintText: 'John',
          prefixIcon: Icons.person,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          label: 'Last Name',
          controller: lastNameController,
          hintText: 'Doe',
          prefixIcon: Icons.person,
        ),

        const SizedBox(height: 16),

        // ─── Email ─────────────────────────────────────────
        CustomTextFormField(
          label: 'Email',
          controller: emailController,
          hintText: 'user@example.com',
          prefixIcon: Icons.mail,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),

        // ─── Password ──────────────────────────────────────
        CustomTextFormField(
          label: 'Password',
          controller: passwordController,
          hintText: 'Enter your password',
          isPassword: true,
          showPassword: showPassword,
          toggleShowPassword: toggleShowPassword,
          prefixIcon: Icons.lock,
        ),
        const SizedBox(height: 16),

        // ─── Confirm Password ─────────────────────────────
        CustomTextFormField(
          label: 'Confirm Password',
          controller: confirmPasswordController,
          hintText: 'Confirm your password',
          isPassword: true,
          showPassword: false,
          toggleShowPassword: null,
          prefixIcon: Icons.lock,
        ),
        const SizedBox(height: 24),

        // ─── Create Account Button ────────────────────────
        GradientButton(
          text: isLoading ? 'Creating account…' : 'Create Account',
          isLoading: isLoading,
          onPressed: () async => await onSubmit(),
        ),
      ],
    );
  }
}
