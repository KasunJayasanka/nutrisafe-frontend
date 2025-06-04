import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;

  final TextEditingController controller;

  final String hintText;

  final bool isPassword;

  final bool showPassword;

  final VoidCallback? toggleShowPassword;

  final TextInputType keyboardType;

  final IconData? prefixIcon;

  final bool enabled;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText = '',
    this.isPassword = false,
    this.showPassword = false,
    this.toggleShowPassword,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.enabled = true,
  });

  OutlineInputBorder _lightGrayBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
        width: 1.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Label ───────────────────────────────────────────
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),

        // ─── TextFormField ───────────────────────────────────
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword && !showPassword,
          enabled: enabled,
          cursorColor: AppColors.textPrimary,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.textSecondary)
                : null,
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                showPassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onPressed: toggleShowPassword,
            )
                : null,
            enabledBorder: _lightGrayBorder(),
            focusedBorder: _lightGrayBorder().copyWith(
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1.5,
              ),
            ),
            errorBorder: _lightGrayBorder().copyWith(
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: _lightGrayBorder().copyWith(
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
          ),
        ),
      ],
    );
  }
}
