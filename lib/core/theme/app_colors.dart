import 'package:flutter/material.dart';

class AppColors {
  // ─── Base Palette ───────────────────────────────────────────────────────────

  /// Pure white
  static const Color white = Color(0xFFFFFFFF);

  /// Pure black
  static const Color black = Color(0xFF000000);

  /// Black with 87% opacity (unchanged, still a const)
  static const Color black87 = Color(0xDD000000);

  /// Grey (for secondary text)
  static const Color grey = Colors.grey;

  // ─── “WelcomeScreen” & Auth‐Screen Specific Colors ─────────────────────────

  /// Emerald‐400 (#10B981)
  static const Color emerald400 = Color(0xFF10B981);

  /// Sky‐400 (#38BDF8)
  static const Color sky400 = Color(0xFF38BDF8);

  /// Indigo‐500 (#6366F1)
  static const Color indigo500 = Color(0xFF6366F1);

  /// Semi‐transparent white at 20% opacity
  static const Color white20 = Color.fromRGBO(255, 255, 255, 0.20);

  /// Semi‐transparent white at 30% opacity
  static const Color white30 = Color.fromRGBO(255, 255, 255, 0.30);

  /// Semi‐transparent white at 70% opacity
  static const Color white70 = Color.fromRGBO(255, 255, 255, 0.70);

  /// Semi‐transparent white at 80% opacity
  static const Color white80 = Color.fromRGBO(255, 255, 255, 0.80);

  /// Semi‐transparent white at 90% opacity
  static const Color white90 = Color.fromRGBO(255, 255, 255, 0.90);

  /// Yellow‐300 (approx. #FFD54F)
  static const Color yellow300 = Color(0xFFFFD54F);

  // ─── Reused App‐Wide Colors ─────────────────────────────────────────────────

  /// Default background for non‐welcome screens
  static const Color background = white;

  /// Primary “NutriSafe” green (fallback green)
  static const Color primary = Color(0xFF3A734F);

  /// Primary text color (black with 87% opacity)
  static const Color textPrimary = black87;

  /// Secondary text color (grey)
  static const Color textSecondary = grey;

  /// Default button background (solid black)
  static const Color buttonBackground = black;

  /// Default button text (white)
  static const Color buttonText = white;
}
