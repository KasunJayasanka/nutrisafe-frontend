// lib/features/onboarding/widgets/mfa_toggle.dart

import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class MfaToggle extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const MfaToggle({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Enable MFA',
            style: Theme.of(context).textTheme.bodyLarge),
        Switch(
          value: enabled,
          onChanged: onChanged,
          activeColor: AppColors.primary,
          inactiveThumbColor: AppColors.cardBackground,
          inactiveTrackColor: AppColors.inputBorder,
        ),
      ],
    );
  }
}
