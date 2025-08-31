// lib/core/widgets/sex_selector.dart
import 'package:flutter/material.dart';
import 'package:frontend_v2/core/enums/sex_option.dart';

class SexSelector extends StatelessWidget {
  final SexOption? value;
  final ValueChanged<SexOption?> onChanged;
  final bool dense;
  final EdgeInsetsGeometry? padding;

  const SexSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.dense = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final tiles = SexOptionX.all.map((opt) {
      return RadioListTile<SexOption>(
        dense: dense,
        title: Text(opt.label),
        value: opt,
        groupValue: value,
        onChanged: onChanged,
      );
    }).toList();

    return Card(
      elevation: 0,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 4),
        child: Column(children: tiles),
      ),
    );
  }
}
