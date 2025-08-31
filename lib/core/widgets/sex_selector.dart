// lib/core/widgets/sex_dropdown_field.dart
import 'package:flutter/material.dart';
import 'package:frontend_v2/core/enums/sex_option.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class SexDropdownField extends StatelessWidget {
  final SexOption? value;
  final ValueChanged<SexOption?> onChanged;
  final String hintText;
  final bool isDense;

  const SexDropdownField({
    super.key,
    required this.value,
    required this.onChanged,
    this.hintText = 'Select sex',
    this.isDense = true,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(8);

    return DropdownButtonFormField<SexOption>(
      value: value,
      isDense: isDense,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: AppColors.emerald200, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: AppColors.emerald600, width: 1.6),
        ),
      ),
      dropdownColor: Colors.white,   // ✅ ensures dropdown menu is white
      items: SexOption.values.map((opt) {
        return DropdownMenuItem<SexOption>(
          value: opt,
          child: Text(opt.label, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
      onChanged: onChanged,
      // ✅ ensures placeholder shows when no value selected
      hint: Text(hintText, style: const TextStyle(color: AppColors.textSecondary)),
    );
  }
}
