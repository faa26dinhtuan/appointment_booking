import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'features/appointments/screens/appointment_shell.dart';
import 'l10n/app_strings.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      locale: AppStrings.locale,
      supportedLocales: const [AppStrings.locale],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: AppTheme.light,
      home: const AppointmentShell(),
    );
  }
}
