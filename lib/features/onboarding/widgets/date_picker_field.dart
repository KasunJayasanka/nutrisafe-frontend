// lib/features/onboarding/widgets/date_picker_field.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final void Function(DateTime) onChanged;
  final IconData? prefixIcon;
  final bool requiredField;

  const DatePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.prefixIcon,
    this.requiredField = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: value == null ? '' : DateFormat('yyyy-MM-dd').format(value!),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(
      label,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: AppColors.textPrimary),  // ← whatever color you want
    ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) onChanged(picked);
          },
          child: AbsorbPointer(
            child: // inside the build of DatePickerField…

            TextFormField(
              controller: controller,
              readOnly: true,
              validator: requiredField
                  ? (s) => (s == null || s.isEmpty) ? 'Required' : null
                  : null,
              decoration: InputDecoration(
                // 1) your placeholder
                hintText: 'yyyy-mm-dd',
                // 2) force it to use your grey
                hintStyle: const TextStyle(color: AppColors.textPrimary),

                filled: true,
                // 3) off-white so the hint actually shows
                fillColor: AppColors.white,

                prefixIcon: prefixIcon != null
                    ? Icon(prefixIcon, color: AppColors.textSecondary)
                    : null,
                suffixIcon:
                Icon(Icons.calendar_month_sharp, color: AppColors.textSecondary),

                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
