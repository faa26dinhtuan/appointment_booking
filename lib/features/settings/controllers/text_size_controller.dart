import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTextSize {
  small(0.90),
  standard(1),
  large(1.15);

  const AppTextSize(this.multiplier);
  final double multiplier;
}

final initialTextSizeProvider = Provider<AppTextSize>(
  (ref) => AppTextSize.standard,
);

final textSizeControllerProvider =
    NotifierProvider<TextSizeController, AppTextSize>(TextSizeController.new);

class TextSizeController extends Notifier<AppTextSize> {
  static const _key = 'app_text_size';
  static final _preferences = SharedPreferencesAsync();

  static Future<AppTextSize> load() async {
    try {
      return switch (await _preferences.getString(_key)) {
        'small' => AppTextSize.small,
        'large' => AppTextSize.large,
        _ => AppTextSize.standard,
      };
    } catch (_) {
      return AppTextSize.standard;
    }
  }

  @override
  AppTextSize build() => ref.watch(initialTextSizeProvider);

  Future<void> select(AppTextSize size) async {
    await _preferences.setString(_key, size.name);
    state = size;
  }
}
