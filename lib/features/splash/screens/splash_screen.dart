// lib/features/splash/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import '../widgets/splash_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate after a short delay (or after auth check)
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/welcome'); // or '/auth'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background to match your app style
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [AppColors.emerald400, AppColors.sky400, AppColors.indigo500],
          ),
        ),
        child: const Center(child: SplashLogo()),
      ),
    );
  }
}
