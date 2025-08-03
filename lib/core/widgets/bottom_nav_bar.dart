// File: lib/core/widgets/bottom_nav_bar.dart

import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        // Indicator behind the selected item (emerald‐50)
        indicatorColor: AppColors.sky50,

        // Icon color depending on selected / unselected
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.emerald600);
            }
            // Unselected icons will be gray
            return const IconThemeData(color: Colors.black54);
          },
        ),

        // Label text style depending on selected / unselected
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: AppColors.emerald600,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              );
            }
            return const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
            );
          },
        ),

        // Background of the entire bar (90% white)
// Replace `Colors.white.withOpacity(0.9)` to avoid the deprecation warning.
        backgroundColor: Colors.white,

        elevation: 4,
      ),
      child: SizedBox(
        // Force the BottomNavigationBar area to be 80px tall (optional)
        height: 80,
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,

          // The “pill” behind each selected destination comes from indicatorColor in the theme.
          // We’ve already provided indicatorColor above, so no need to re‐specify it here.

          height: 80, // ensures the bar fits our SizedBox height

          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.restaurant_outlined),
              selectedIcon: Icon(Icons.restaurant),
              label: 'Food',
            ),
            NavigationDestination(
              icon: Icon(Icons.flag_outlined),
              selectedIcon: Icon(Icons.flag),
              label: 'Goals',
            ),
            NavigationDestination(
              icon: Icon(Icons.trending_up_outlined),
              selectedIcon: Icon(Icons.trending_up),
              label: 'Analytics',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
