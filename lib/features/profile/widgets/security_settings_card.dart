import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class SecuritySettingsCard extends StatelessWidget {
  final AsyncValue<bool> mfaAsync;
  final ValueChanged<bool> onToggle;

  const SecuritySettingsCard({
    Key? key,
    required this.mfaAsync,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: mfaAsync.when(
          data: (enabled) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.shield, color: AppColors.emerald600),
                  const SizedBox(width: 8),
                  const Text(
                    'Security Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // MFA toggle row
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6), // grey-50
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shield, color: AppColors.emerald600),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Enable Two-Factor Authentication',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Add an extra layer of security to your account',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: enabled,
                      activeColor: AppColors.emerald600,
                      onChanged: onToggle,
                    ),
                  ],
                ),
              ),

              // Enabled banner
              if (enabled) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.emerald50,
                    border: Border.all(color: AppColors.emerald200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.shield, size: 20, color: AppColors.emerald600),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Two-factor authentication is enabled. '
                              'You’ll receive a code via email when logging in.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.emerald600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          loading: () => SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, st) => SizedBox(
            height: 100,
            child: Center(child: Text('Error: $e')),
          ),
        ),
      ),
    );
  }
}
