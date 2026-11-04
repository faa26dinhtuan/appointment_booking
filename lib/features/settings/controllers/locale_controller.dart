import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../l10n/app_strings.dart';

final initialLocaleProvider = Provider<Locale>((ref) => AppStrings.vietnamese);

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

class LocaleController extends Notifier<Locale> {
  static const _key = 'app_language';
  static final _preferences = SharedPreferencesAsync();

  static Future<Locale> load() async {
    try {
      final code = await _preferences.getString(_key);
      return code == 'en' ? AppStrings.english : AppStrings.vietnamese;
    } catch (_) {
      return AppStrings.vietnamese;
    }
  }

  @override
  Locale build() => ref.watch(initialLocaleProvider);

  Future<void> select(Locale locale) async {
    await _preferences.setString(_key, locale.languageCode);
    state = locale;
  }
}
