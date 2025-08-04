// lib/features/onboarding/widgets/number_input_field.dart

import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class NumberInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String suffix;
  final IconData? prefixIcon;
  final bool requiredField;

  const NumberInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.suffix,
    this.prefixIcon,
    this.requiredField = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label above the field
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),

        // The text input itself
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          validator: requiredField
              ? (s) => (s == null || s.isEmpty) ? 'Required' : null
              : null,
          decoration: InputDecoration(
            hintText: '90',
            hintStyle: const TextStyle(color: AppColors.textPrimary),

            filled: true,
            fillColor: AppColors.white,

            // same padding
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

            // optional prefix icon in grey
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.textSecondary)
                : null,

            // your unit text in grey, at the end
            suffixText: suffix,
            suffixStyle: const TextStyle(color: AppColors.textSecondary),

            // same 8px rounded grey border
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),

            // same primary‐coloured thicker border on focus
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
