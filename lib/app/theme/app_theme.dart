import 'package:flutter/material.dart';

class AppTheme {
  // Color principal de la app
  static const Color primaryColor = Colors.purple;

  // Colores personalizados del tema oscuro
  static const Color scaffoldBackground = Color(0xFF11181F);
  static const Color cardBackground = Color(0xFF1C252F);
  static const Color appBarBackground = Color(0xFF1C252F);

  // Tema oscuro
  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: scaffoldBackground,
      cardColor: cardBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: appBarBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  // Tema claro
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }
}
