import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/logo_section.dart';
import '../widgets/title_section.dart';
import '../widgets/progress_section.dart';
import '../widgets/feature_block.dart';
import '/../../core/theme/app_colors.dart';

class WelcomeScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const WelcomeScreen({super.key, required this.onComplete});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int progress = 0;
  Timer? _timer;
  double _opacityLevel = 0.0;

  @override
  void initState() {
    super.initState();

    // Fade‐in animation
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() => _opacityLevel = 1.0);
    });

    // Progress bar timer: increase by 10 every 150 ms
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        if (progress >= 100) {
          timer.cancel();
          Future.delayed(const Duration(milliseconds: 500),
              widget.onComplete);
          progress = 100;
        } else {
          progress += 10;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Returns the status text based on [progress].
  String get _statusText {
    if (progress < 30) {
      return "Initializing…";
    } else if (progress < 70) {
      return "Loading your data…";
    } else if (progress < 100) {
      return "Almost ready…";
    } else {
      return "Welcome!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Full‐screen gradient (emerald → sky → indigo)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.emerald400,
              AppColors.sky400,
              AppColors.indigo500,
            ],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        child: AnimatedOpacity(
          // Fade‐in wrapper
          opacity: _opacityLevel,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeIn,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ——— Logo Section ———
              const LogoSection(),

              const SizedBox(height: 24),

              // ——— Title / Subtitle / Description ———
              const TitleSection(),

              const SizedBox(height: 32),

              // ——— Progress Bar + Status Text ———
              ProgressSection(
                progress: progress,
                statusText: _statusText,
              ),

              const SizedBox(height: 48),

              // ——— Features Preview ———
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  FeatureBlock(emoji: '🥗', label: 'Food Tracking'),
                  FeatureBlock(emoji: '🛡️', label: 'Safety Analysis'),
                  FeatureBlock(emoji: '📊', label: 'Analytics'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
