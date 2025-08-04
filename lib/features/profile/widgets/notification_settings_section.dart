// File: lib/features/profile/widgets/notification_settings_section.dart

import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class NotificationSettingsSection extends StatelessWidget {
  final bool meals;
  final bool goals;
  final bool safety;
  final bool weekly;

  final ValueChanged<bool> onMealsChanged;
  final ValueChanged<bool> onGoalsChanged;
  final ValueChanged<bool> onSafetyChanged;
  final ValueChanged<bool> onWeeklyChanged;

  const NotificationSettingsSection({
    Key? key,
    required this.meals,
    required this.goals,
    required this.safety,
    required this.weekly,
    required this.onMealsChanged,
    required this.onGoalsChanged,
    required this.onSafetyChanged,
    required this.onWeeklyChanged,
  }) : super(key: key);

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            activeColor: AppColors.emerald600,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // ─── Section Header ───────────────────────────
          ListTile(
            leading:
            const Icon(Icons.notifications, color: AppColors.textSecondary),
            title: const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // ─── Switch Rows ───────────────────────────────
          _buildSwitchRow(
            title: 'Meal Reminders',
            subtitle: 'Get notified about meal times',
            value: meals,
            onChanged: onMealsChanged,
          ),
          _buildSwitchRow(
            title: 'Goal Alerts',
            subtitle: 'Daily goal achievement updates',
            value: goals,
            onChanged: onGoalsChanged,
          ),
          _buildSwitchRow(
            title: 'Safety Alerts',
            subtitle: 'Food safety notifications',
            value: safety,
            onChanged: onSafetyChanged,
          ),
          _buildSwitchRow(
            title: 'Weekly Reports',
            subtitle: 'Progress summaries',
            value: weekly,
            onChanged: onWeeklyChanged,
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
