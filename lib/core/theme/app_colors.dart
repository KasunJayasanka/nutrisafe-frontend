import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Base Palette ───────────────────────────────────────────────────────────

  /// Pure white
  static const Color white = Color(0xFFFFFFFF);

  /// Pure black
  static const Color black = Color(0xFF000000);

  /// Black with 87% opacity
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
  static const Color textSecondary = black;

  /// Default button background (solid black)
  static const Color buttonBackground = black;

  /// Default button text (white)
  static const Color buttonText = white;

  // emerald (green) shades
  static const Color emerald50 = Color(0xFFECFDF5);
  static const Color emerald100 = Color(0xFFD1FAE5);
  static const Color emerald200 = Color(0xFFA7F3D0);
  static const Color emerald500 = Color(0xFF059669);
  static const Color emerald600 = Color(0xFF047857);
  static const emerald700  = Color(0xFF047857);


  // sky (blue) shades
  static const Color sky50 = Color(0xFFF0F9FF);
  static const Color sky100 = Color(0xFFE0F2FE);
  static const Color sky500 = Color(0xFF0EA5E9);
  static const Color sky600 = Color(0xFF0284C7);

  // amber (yellow) shades
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color amber600 = Color(0xFFD97706);

  static const Color orange600 = Color(0xFFEA580C);

  // Red (for “Sign Out” button border)
  static const Color red200 = Color(0xFFFECACA);
  static const Color red600 = Color(0xFFDC2626);

  // ─── Background & Cards ─────────────────────────────────────────────────────

  /// Screen background gradient start (emerald50 – #ECFDF5)
  static const Color backgroundGradientStart = Color(0xFFECFDF5);

  /// Screen background gradient end (sky50 – #F0F9FF)
  static const Color backgroundGradientEnd = Color(0xFFF0F9FF);

  /// White card background
  static const Color cardBackground = white;

  // ─── Inputs ─────────────────────────────────────────────────────────────────

  /// Very light fill for inputs (gray-50 – #F9FAFB)
  static const Color inputFill = Color(0xFFF9FAFB);

  /// Light gray border for inputs (#E5E7EB)
  static const Color inputBorder = Color(0xFFE5E7EB);

  // ─── Buttons & Accents ──────────────────────────────────────────────────────

  /// Button gradient start (emerald500 – #059669)
  static const Color buttonGradientStart = Color(0xFF059669);

  /// Button gradient end (sky500 – #0EA5E9)
  static const Color buttonGradientEnd = Color(0xFF0EA5E9);

  /// Pale emerald upload-button fill (emerald100 – #D1FAE5)
  static const Color uploadButtonBackground = Color(0xFFD1FAE5);


  static const Color blue600   = Color(0xFF1E88E5);
  static const Color pink600   = Color(0xFFD81B60);
  static const Color teal600   = Color(0xFF009688);
  static const Color purple600 = Color(0xFF8E24AA);

}
