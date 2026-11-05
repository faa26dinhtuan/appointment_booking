import 'package:flutter/widgets.dart';

abstract final class BrandAssets {
  static const appointmentList = 'assets/icons/appointment_list.png';
  static const calendar = 'assets/icons/calendar.png';
  static const settings = 'assets/icons/settings.png';
  static const language = 'assets/icons/language.png';
  static const appearance = 'assets/icons/appearance.png';
  static const textSize = 'assets/icons/text_size.png';
  static const profile = 'assets/icons/profile.png';
  static const passwordLock = 'assets/icons/password_lock.png';
  static const signOut = 'assets/icons/sign_out.png';
  static const info = 'assets/icons/info.png';

  static const calendarCheck = 'assets/icons/calendar_check.png';
  static const calendarEmpty = 'assets/icons/calendar_empty.png';
  static const clock = 'assets/icons/clock.png';
  static const locationPin = 'assets/icons/location_pin.png';
  static const completed = 'assets/icons/completed.png';
  static const canceled = 'assets/icons/canceled.png';
  static const loginIllustration = 'assets/images/login_illustration.png';

  static Image icon(String asset, {double size = 24}) =>
      Image.asset(asset, width: size, height: size, excludeFromSemantics: true);
}
