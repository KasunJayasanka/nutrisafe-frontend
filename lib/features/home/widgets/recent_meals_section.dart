// File: lib/features/home/widgets/recent_meals_section.dart

import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class RecentMealsSection extends StatelessWidget {
  final List<Map<String, dynamic>> recentLogs;

  const RecentMealsSection({
    Key? key,
    required this.recentLogs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // ─── Section Header (“Recent Meals”) ─────────────────
          ListTile(
            leading: const Icon(
              Icons.access_time,
              color: AppColors.textSecondary,
            ),
            title: const Text(
              'Recent Meals',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Title in black
              ),
            ),
          ),

          // ─── Each Meal Row ───────────────────────────────────
          ...recentLogs.map((log) {
            final isSafe = log['safety'] == 'safe';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ─── Left side: Icon + Food Name + Timestamp ─────
                  Row(
                    children: [
                      const Icon(
                        Icons.restaurant,
                        color: AppColors.emerald600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Food name in black
                          Text(
                            log['food'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Timestamp in black
                          Text(
                            log['time'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // ─── Right side: Calories + Badge ────────────────
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Calories in black
                      Text(
                        '${log['calories']} cal',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // “Safe” / “Check” badge text in black
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.emerald50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.emerald200),
                        ),
                        child: Text(
                          isSafe ? 'Safe' : 'Check',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black, // Badge text in black
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),

          // ─── Bottom Padding ──────────────────────────────────
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
