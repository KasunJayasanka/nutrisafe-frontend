import 'package:flutter/material.dart';
import 'package:frontend_v2/features/auth/screens/auth_screen.dart';
import 'core/theme/app_theme.dart';
import 'features/home/screens/welcome_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NutriSafe',
      theme: appTheme,

      home: Builder(
        builder: (innerContext) {
          return WelcomeScreen(
            onComplete: () {
              Navigator.of(innerContext).pushReplacement(
                MaterialPageRoute(
                  builder: (_) =>  AuthScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
