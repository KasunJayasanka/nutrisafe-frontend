import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class NotificationSettingsSection extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const NotificationSettingsSection({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: const Icon(Icons.notifications, color: AppColors.textSecondary),
          title: const Text(
            'Notifications',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          subtitle: Text(
            enabled ? 'Push notifications are ON' : 'Push notifications are OFF',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          trailing: Switch(
            value: enabled,
            activeColor: AppColors.emerald600,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
