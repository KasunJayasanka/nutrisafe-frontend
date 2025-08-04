import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class AppInfoSection extends StatelessWidget {
  const AppInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: const [
            Text(
              'HealthTrack v1.0.0',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 4),
            Text(
              'Smart nutrition for athletes',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
