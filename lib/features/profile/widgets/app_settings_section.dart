import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class AppSettingsSection extends StatelessWidget {
  final VoidCallback onPrivacyPressed;
  final VoidCallback onHelpPressed;
  final VoidCallback onSignOutPressed;

  const AppSettingsSection({
    Key? key,
    required this.onPrivacyPressed,
    required this.onHelpPressed,
    required this.onSignOutPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // ─── Section Header ───────────────────────────
          ListTile(
            leading: const Icon(Icons.settings, color: AppColors.textSecondary),
            title: const Text(
              'App Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                // ─── Privacy & Security Button ───────────────
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    side: const BorderSide(color: AppColors.textSecondary),
                    foregroundColor: Colors.black, // ← was `primary:` before
                  ),
                  onPressed: onPrivacyPressed,
                  icon: const Icon(Icons.lock_outline, size: 18, color: Colors.black),
                  label: const Text(
                    'Privacy & Security',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),

                const SizedBox(height: 8),

                // ─── Help & Support Button ───────────────────
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    side: const BorderSide(color: AppColors.textSecondary),
                    foregroundColor: Colors.black, // ← was `primary:` before
                  ),
                  onPressed: onHelpPressed,
                  icon: const Icon(Icons.help_outline, size: 18, color: Colors.black),
                  label: const Text(
                    'Help & Support',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),

                const SizedBox(height: 8),

                // ─── Sign Out Button ─────────────────────────
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    side: const BorderSide(color: Colors.redAccent), // use your desired border color
                    foregroundColor: Colors.redAccent, // ← was `primary:` before
                  ),
                  onPressed: onSignOutPressed,
                  icon: const Icon(Icons.logout, size: 18, color: Colors.redAccent),
                  label: const Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 14, color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
