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
  });

  final Color accent;
  final Color background;
  final Color surface;
  final Color border;
  final Color ink;
  final Color muted;

  static const bodyTextSize = 16.0;
  static const headingTextSize = 30.0;
  static const small = 8.0;
  static const medium = 16.0;
  static const large = 24.0;
  static const contentWidth = 520.0;
  static const corners = BorderRadius.all(Radius.circular(20));

  static const _light = AppTheme._(
    accent: Color(0xFF4743A3),
    background: Color(0xFFF5F5FC),
    surface: Color(0xFFFCFCFF),
    border: Color(0xFFE4E2F0),
    ink: Color(0xFF262440),
    muted: Color(0xFF605D79),
  );

  static const _dark = AppTheme._(
    accent: Color(0xFFAAA7FF),
    background: Color(0xFF151423),
    surface: Color(0xFF222136),
    border: Color(0xFF3C3957),
    ink: Color(0xFFF2EFFF),
    muted: Color(0xFFC3BED9),
  );

  static AppTheme of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _dark : _light;

  static final light = _light._build(Brightness.light);
  static final dark = _dark._build(Brightness.dark);

  BoxDecoration get card => BoxDecoration(
    color: surface,
    borderRadius: corners,
    border: Border.fromBorderSide(BorderSide(color: border)),
    boxShadow: const [
      BoxShadow(color: Color(0x0D000000), blurRadius: 20, offset: Offset(0, 8)),
    ],
  );

  BoxDecoration get field =>
      BoxDecoration(color: background, borderRadius: corners);

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
