// File: lib/main.dart

import 'package:flutter/material.dart';
import 'package:frontend_v2/features/splash/screens/splash_screen.dart';
import 'package:frontend_v2/features/auth/screens/auth_screen.dart';
import 'package:frontend_v2/features/home/screens/dashboard_screen.dart';
import 'package:frontend_v2/features/home/screens/welcome_screen.dart';
import 'package:frontend_v2/features/profile/screens/profile_screen.dart';
import 'package:frontend_v2/features/meal_logging/screens/food_logger_screen.dart';
import 'features/goals/screens/goals_screen.dart';
import 'features/goals/screens/goals_history_screen.dart';
import 'features/analytics/screens/analytics_screen.dart';



import 'core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NutriSafe',
      theme: appTheme,

      /// Use `initialRoute` and a `routes:` table instead of a single `home:`.
      initialRoute: '/',
      routes: {
        /// "/" → WelcomeScreen
        '/'        : (ctx) => WelcomeScreen(
          onComplete: () {
            Navigator.of(ctx).pushReplacementNamed('/auth');
          },
        ),

        /// "/auth" → your AuthScreen
        '/auth'    : (ctx) => AuthScreen(),

        /// "/dashboard" → the main DashboardScreen
        '/dashboard': (ctx) => const DashboardScreen(),

        /// "/profile" → the ProfileScreen
        '/profile' : (ctx) => const ProfileScreen(),

        '/food' : (ctx) => const FoodLoggerScreen(),

        '/goals': (ctx) => const GoalsScreen(),
        '/goals/history': (ctx) => const GoalsHistoryScreen(),

        '/analytics': (ctx) => const AnalyticsScreen(),
      },
    );
  }
}
