import '../../l10n/app_strings.dart';

abstract final class AuthValidation {
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? email(String? value, AppStrings strings) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return strings.emailRequired;
    if (!_emailPattern.hasMatch(email)) return strings.emailInvalid;
    return null;
  }

  static String? newPassword(String? value, AppStrings strings) {
    if (value == null || value.isEmpty) return strings.passwordRequired;
    if (value.runes.length < 6) return strings.passwordTooShort;
    return null;
  }
}
