import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../l10n/app_strings.dart';

final initialDateFormatProvider = Provider<AppDateFormat>(
  (ref) => AppDateFormat.localized,
);

final dateFormatControllerProvider =
    NotifierProvider<DateFormatController, AppDateFormat>(
      DateFormatController.new,
    );

class DateFormatController extends Notifier<AppDateFormat> {
  static const _key = 'app_date_format';
  static final _preferences = SharedPreferencesAsync();

  static Future<AppDateFormat> load() async {
    try {
      final saved = await _preferences.getString(_key);
      return AppDateFormat.values.firstWhere(
        (format) => format.name == saved,
        orElse: () => AppDateFormat.localized,
      );
    } catch (_) {
      return AppDateFormat.localized;
    }
  }

  @override
  AppDateFormat build() => ref.watch(initialDateFormatProvider);

  Future<void> select(AppDateFormat format) async {
    await _preferences.setString(_key, format.name);
    state = format;
  }
}
