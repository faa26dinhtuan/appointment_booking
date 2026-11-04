import '../../l10n/app_strings.dart';

abstract final class AuthValidation {
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return AppStrings.emailRequired;
    if (!_emailPattern.hasMatch(email)) return AppStrings.emailInvalid;
    return null;
  }

  static String? newPassword(String? value) {
    if (value == null || value.isEmpty) return AppStrings.passwordRequired;
    if (value.runes.length < 6) return AppStrings.passwordTooShort;
    return null;
  }
}
