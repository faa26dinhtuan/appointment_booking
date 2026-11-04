import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const accent = Color(0xFF4743A3);
  static const background = Color(0xFFF5F5FC);
  static const surface = Color(0xFFFCFCFF);
  static const border = Color(0xFFE4E2F0);
  static const ink = Color(0xFF262440);
  static const muted = Color(0xFF605D79);
  static const small = 8.0;
  static const medium = 16.0;
  static const large = 24.0;
  static const contentWidth = 520.0;
  static const corners = BorderRadius.all(Radius.circular(20));

  static const card = BoxDecoration(
    color: surface,
    borderRadius: corners,
    border: Border.fromBorderSide(BorderSide(color: border)),
    boxShadow: [
      BoxShadow(color: Color(0x0D000000), blurRadius: 20, offset: Offset(0, 8)),
    ],
  );

  static const field = BoxDecoration(color: background, borderRadius: corners);

  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: accent),
    cupertinoOverrideTheme: const CupertinoThemeData(
      primaryColor: accent,
      scaffoldBackgroundColor: background,
      barBackgroundColor: Color(0xF2FCFCFF),
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(color: ink, fontSize: 17),
      ),
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(backgroundColor: background),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(borderRadius: corners),
    ),
  );
}
