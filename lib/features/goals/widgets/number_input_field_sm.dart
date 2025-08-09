// File: lib/features/goals/widgets/number_input_field_sm.dart
import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class NumberInputFieldSm extends StatelessWidget {
  final int value;
  final void Function(int) onChanged;
  final String? suffix;
  final bool highlight;

  const NumberInputFieldSm({
    super.key,
    required this.value,
    required this.onChanged,
    this.suffix,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: highlight ? AppColors.emerald400 : const Color(0xFFE5E7EB),
        width: highlight ? 1.5 : 1,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: AppColors.sky400,
        width: 2,
      ),
    );

    return SizedBox(
      width: 92,
      child: TextFormField(
        initialValue: value.toString(),
        keyboardType: TextInputType.number,
        onChanged: (v) => onChanged(int.tryParse(v) ?? value),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          suffixText: suffix,
          suffixStyle: const TextStyle( // ⬅️ Added to make unit black
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          border: baseBorder,
          enabledBorder: baseBorder,
          focusedBorder: focusedBorder,
          filled: highlight,
          fillColor: highlight ? AppColors.emerald50.withOpacity(0.6) : null,
        ),
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}
