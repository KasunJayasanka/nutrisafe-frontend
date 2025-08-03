// File: lib/features/home/widgets/alerts_section.dart

import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class AlertsSection extends StatelessWidget {
  final List<Map<String, String>> alerts;

  const AlertsSection({Key? key, required this.alerts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // ─── Section Header (“Alerts & Recommendations”) ─────
          ListTile(
            leading: const Icon(Icons.security, color: AppColors.amber600),
            title: const Text(
              'Alerts & Recommendations',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Title text in black
              ),
            ),
          ),

          // ─── Each Alert Row ─────────────────────────────────
          ...alerts.map((alert) {
            final isWarning = alert['type'] == 'warning';
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isWarning ? Icons.warning_amber_rounded : Icons.check_circle,
                    color: isWarning ? AppColors.amber500 : AppColors.emerald500,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Alert message in black
                        Text(
                          alert['message']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Timestamp in black
                        Text(
                          alert['time']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
