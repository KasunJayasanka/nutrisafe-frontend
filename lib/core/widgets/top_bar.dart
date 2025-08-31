// File: lib/core/widgets/top_bar.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBellTap;

  const TopBar({Key? key, this.onBellTap}) : super(key: key);

  // Increase from 64 to 80 so that after SafeArea inset, there's ~56px left
  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: preferredSize.height,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                // ─── Gradient Circle + Heart Icon ─────────────────────
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.emerald400, AppColors.sky400],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.favorite,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // ─── Title & Subtitle (shrink to fit) ──────────────────
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nutrivue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [AppColors.emerald400, AppColors.sky400],
                          ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Smart Nutrition',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // ─── Bell Icon ─────────────────────────────────────────
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                  onPressed: onBellTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
