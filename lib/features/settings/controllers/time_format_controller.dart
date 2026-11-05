import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final initialUse24HourProvider = Provider<bool>((ref) => true);

final timeFormatControllerProvider =
    NotifierProvider<TimeFormatController, bool>(TimeFormatController.new);

class TimeFormatController extends Notifier<bool> {
  static const _key = 'app_use_24_hour_format';
  static final _preferences = SharedPreferencesAsync();

  static Future<bool> load() async {
    try {
      return await _preferences.getBool(_key) ?? true;
    } catch (_) {
      return true;
    }
  }

  @override
  bool build() => ref.watch(initialUse24HourProvider);

  Future<void> select(bool use24Hour) async {
    await _preferences.setBool(_key, use24Hour);
    state = use24Hour;
  }
}
