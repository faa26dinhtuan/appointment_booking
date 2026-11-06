import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

abstract final class AnalyticsService {
  static Future<void> recordAppOpen() async {
    if (!kIsWeb &&
        defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS &&
        defaultTargetPlatform != TargetPlatform.macOS) {
      return;
    }

    try {
      await FirebaseAnalytics.instance.logAppOpen();
    } catch (error) {
      debugPrint('Analytics app_open failed: ${error.runtimeType}');
    }
  }
}
