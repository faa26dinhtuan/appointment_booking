import 'package:flutter/widgets.dart';

abstract final class BrandAssets {
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
