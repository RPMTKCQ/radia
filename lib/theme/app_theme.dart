import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFF0A0A0A);
  static const surface = Color(0xFF1C1C1E);
  static const surface2 = Color(0xFF2A2A2D);
  static const maroon = Color(0xFF4A0E1E);
  static const maroonLight = Color(0xFF6B1A2E);
  static const yellow = Color(0xFFFFD60A);
  static const green = Color(0xFF22C55E);
  static const red = Color(0xFFEF4444);
  static const amber = Color(0xFFF59E0B);
}

ThemeData buildAppTheme() => ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(primary: AppColors.yellow),
    );
