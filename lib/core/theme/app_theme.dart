import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  primaryColor: Colors.black,
  textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
  appBarTheme: const AppBarTheme(
    color: Colors.black,
    elevation: 0,
  ),
  colorScheme: ColorScheme.dark(
    primary: Colors.black,
    secondary: Colors.white, // replaces accentColor
  ),
);
