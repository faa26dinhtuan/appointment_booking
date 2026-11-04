import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const accent = Color(0xFF4743A3);
  static const background = Color(0xFFF5F5FC);
  static const small = 8.0;
  static const medium = 16.0;
  static const large = 24.0;
  static const contentWidth = 520.0;
  static const corners = BorderRadius.all(Radius.circular(20));

  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: accent),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(backgroundColor: background),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(borderRadius: corners),
    ),
  );
}
