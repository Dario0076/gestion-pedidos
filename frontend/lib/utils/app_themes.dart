import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';

class AppThemes {
  static ThemeData lightTheme(ThemeState themeState) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _getSeedColor(themeState.colorScheme),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: _getSeedColor(themeState.colorScheme),
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
      ),
    );
  }

  static ThemeData darkTheme(ThemeState themeState) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _getSeedColor(themeState.colorScheme),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: _getSeedColor(themeState.colorScheme),
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: Colors.grey[850],
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[800],
      ),
    );
  }

  static ThemeMode getThemeMode(ThemeState themeState) {
    switch (themeState.themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  static Color _getSeedColor(AppColorScheme colorScheme) {
    switch (colorScheme) {
      case AppColorScheme.blue:
        return const Color(0xFF2196F3);
      case AppColorScheme.green:
        return const Color(0xFF4CAF50);
      case AppColorScheme.purple:
        return const Color(0xFF9C27B0);
      case AppColorScheme.orange:
        return const Color(0xFFFF9800);
      case AppColorScheme.red:
        return const Color(0xFFF44336);
    }
  }
}
