import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final initialThemeModeProvider = Provider<ThemeMode>((ref) => ThemeMode.system);

final themeControllerProvider = NotifierProvider<ThemeController, ThemeMode>(
  ThemeController.new,
);

class ThemeController extends Notifier<ThemeMode> {
  static const _key = 'app_theme_mode';
  static final _preferences = SharedPreferencesAsync();

  static Future<ThemeMode> load() async {
    try {
      return switch (await _preferences.getString(_key)) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
    } catch (_) {
      return ThemeMode.system;
    }
  }

  @override
  ThemeMode build() => ref.watch(initialThemeModeProvider);

  Future<void> select(ThemeMode mode) async {
    await _preferences.setString(_key, mode.name);
    state = mode;
  }
}
