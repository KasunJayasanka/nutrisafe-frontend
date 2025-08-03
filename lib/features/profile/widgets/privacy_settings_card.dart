import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class PrivacySettingsCard extends StatelessWidget {
  const PrivacySettingsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: const [
                Icon(Icons.privacy_tip, color: AppColors.emerald600),
                SizedBox(width: 8),
                Text(
                  'Privacy Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Placeholder content in grey container
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6), // grey-50
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Additional privacy settings will be available soon.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
