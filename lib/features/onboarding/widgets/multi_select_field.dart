// lib/features/onboarding/widgets/multi_select_field.dart

import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class MultiSelectField<T> extends StatelessWidget {
  final String label;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final List<T> selectedValues;
  final void Function(List<T>) onChanged;
  final IconData? prefixIcon;
  final bool requiredField;

  const MultiSelectField({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    required this.selectedValues,
    required this.onChanged,
    this.prefixIcon,
    this.requiredField = false,
  });

  @override
  Widget build(BuildContext context) {
    // Map value → its child widget
    final labelMap = { for (var i in items) i.value!: i.child };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),

        // Tappable box that opens the dialog
        GestureDetector(
          onTap: () async {
            // temp copy of current selection
            final temp = List<T>.from(selectedValues);
            final result = await showDialog<List<T>>(
              context: context,
              builder: (_) => StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    backgroundColor: AppColors.emerald50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Text(
                      label,
                      style: GoogleFonts.poppins(
                        color: AppColors.emerald600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: items.map((item) {
                          final val = item.value!;
                          final itemLabel = (item.child as Text).data ?? '';
                          final isSelected = temp.contains(val);
                          return ListTile(
                            title: Text(
                              itemLabel,
                              style: const TextStyle(color: AppColors.black),
                            ),
                            trailing: isSelected
                                ? Icon(Icons.check, color: AppColors.emerald600)
                                : null,
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  temp.remove(val);
                                } else {
                                  if (!temp.contains(val)) {
                                    temp.add(val);
                                  }
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, selectedValues),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: AppColors.emerald600),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emerald600,
                        ),
                        onPressed: () => Navigator.pop(context, temp),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              ),
            );
            if (result != null) {
              onChanged(result);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: selectedValues.isEmpty ? hintText : null,
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.inputFill,
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: AppColors.textSecondary)
                  : null,
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
            isEmpty: selectedValues.isEmpty,
            child: selectedValues.isEmpty
                ? null
                : Wrap(
              spacing: 6,
              runSpacing: -8,
              children: selectedValues.map((val) {
                final textWidget = labelMap[val] as Text;
                return Chip(
                  label: textWidget,
                  backgroundColor: AppColors.emerald400,
                  materialTapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
          ),
        ),

        // Validation error
        if (requiredField && selectedValues.isEmpty) ...[
          const SizedBox(height: 4),
          Text('Please select at least one',
              style: TextStyle(color: Colors.red[700])),
        ],
      ],
    );
  }
}
