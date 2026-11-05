import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final class AppTheme {
  const AppTheme._({
    required this.accent,
    required this.background,
    required this.surface,
    required this.border,
    required this.ink,
    required this.muted,
    required this.peach,
    required this.sky,
    required this.success,
    required this.danger,
  });

  final Color accent;
  final Color background;
  final Color surface;
  final Color border;
  final Color ink;
  final Color muted;
  final Color peach;
  final Color sky;
  final Color success;
  final Color danger;

  static const bodyTextSize = 16.0;
  static const headingTextSize = 30.0;
  static const small = 8.0;
  static const medium = 16.0;
  static const large = 24.0;
  static const contentWidth = 520.0;
  static const captionTextSize = 13.0;
  static const sectionTextSize = 22.0;
  static const pagePadding = 16.0;
  static const pill = BorderRadius.all(Radius.circular(32));
  static const corners = BorderRadius.all(Radius.circular(20));

  static const _light = AppTheme._(
    accent: Color(0xFF2156A0),
    background: Color(0xFFFAF6F0),
    surface: Color(0xFFFFFEFC),
    border: Color(0xFFE9DFD5),
    ink: Color(0xFF232A37),
    muted: Color(0xFF5B6472),
    peach: Color(0xFFF8DCCF),
    sky: Color(0xFFDEEBF8),
    success: Color(0xFF26684F),
    danger: Color(0xFF9E3F4B),
  );

  static const _dark = AppTheme._(
    accent: Color(0xFFA9CCFF),
    background: Color(0xFF161920),
    surface: Color(0xFF222732),
    border: Color(0xFF3C4555),
    ink: Color(0xFFF7F1EA),
    muted: Color(0xFFBEC6D3),
    peach: Color(0xFF493237),
    sky: Color(0xFF263B55),
    success: Color(0xFF9DE0BE),
    danger: Color(0xFFF4A6AF),
  );

  static AppTheme of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _dark : _light;

  static final light = _light._build(Brightness.light);
  static final dark = _dark._build(Brightness.dark);

  TextStyle get sectionTitle => TextStyle(
    color: ink,
    fontSize: sectionTextSize,
    fontWeight: FontWeight.w700,
  );

  TextStyle get caption => TextStyle(color: muted, fontSize: captionTextSize);

  BoxDecoration get agendaBanner => BoxDecoration(
    borderRadius: corners,
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [peach, background, sky],
    ),
  );

  BoxDecoration get card => BoxDecoration(
    color: surface,
    borderRadius: corners,
    border: Border.fromBorderSide(BorderSide(color: border)),
    boxShadow: const [
      BoxShadow(color: Color(0x0D000000), blurRadius: 20, offset: Offset(0, 8)),
    ],
  );

  BoxDecoration get field => BoxDecoration(
    color: background,
    borderRadius: corners,
    border: Border.all(color: border),
  );

  ThemeData _build(Brightness brightness) => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: accent,
      brightness: brightness,
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: brightness,
      primaryColor: accent,
      primaryContrastingColor: brightness == Brightness.dark
          ? background
          : surface,
      scaffoldBackgroundColor: background,
      barBackgroundColor: surface.withAlpha(242),
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(color: ink, fontSize: bodyTextSize),
        navLargeTitleTextStyle: const CupertinoTextThemeData()
            .navLargeTitleTextStyle
            .copyWith(
              color: ink,
              fontSize: headingTextSize,
              fontWeight: FontWeight.w700,
            ),
      ),
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(backgroundColor: background),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(borderRadius: corners),
    ),
  );
}
