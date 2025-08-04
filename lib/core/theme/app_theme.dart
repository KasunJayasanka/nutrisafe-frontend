import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';


final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.black,
  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
  bodyLarge: const TextStyle(color: AppColors.textPrimary),
  bodyMedium: const TextStyle(color: AppColors.textSecondary),
 ),
  appBarTheme: const AppBarTheme(
    color: Colors.black,
    elevation: 0,
  ),
  colorScheme: ColorScheme.dark(
    primary: Colors.white,
    secondary: Colors.black, // replaces accentColor
  ),
);
