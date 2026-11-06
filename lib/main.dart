import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/app_text_scaler.dart';
import 'core/widgets/app_splash_screen.dart';
import 'features/appointments/screens/appointment_shell.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/settings/controllers/locale_controller.dart';
import 'features/settings/controllers/date_format_controller.dart';
import 'features/settings/controllers/theme_controller.dart';
import 'features/settings/controllers/text_size_controller.dart';
import 'features/settings/controllers/time_format_controller.dart';
import 'data/services/analytics_service.dart';
import 'firebase_options.dart';
import 'l10n/app_strings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final (locale, themeMode, textSize, use24Hour, dateFormat) = await (
    LocaleController.load(),
    ThemeController.load(),
    TextSizeController.load(),
    TimeFormatController.load(),
    DateFormatController.load(),
  ).wait;
  runApp(
    ProviderScope(
      overrides: [
        initialLocaleProvider.overrideWithValue(locale),
        initialThemeModeProvider.overrideWithValue(themeMode),
        initialTextSizeProvider.overrideWithValue(textSize),
        initialUse24HourProvider.overrideWithValue(use24Hour),
        initialDateFormatProvider.overrideWithValue(dateFormat),
      ],
      child: MyApp(initialization: _initializeFirebase()),
    ),
  );
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  unawaited(AnalyticsService.recordAppOpen());
}

class MyApp extends ConsumerWidget {
  const MyApp({required this.initialization, super.key});

  final Future<void> initialization;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textSize = ref.watch(textSizeControllerProvider);
    final use24Hour = ref.watch(timeFormatControllerProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.productName,
      locale: ref.watch(localeControllerProvider),
      supportedLocales: AppStrings.supportedLocales,
      localizationsDelegates: [
        AppStrings.delegate(ref.watch(dateFormatControllerProvider)),
        ...GlobalMaterialLocalizations.delegates,
      ],
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeControllerProvider),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            alwaysUse24HourFormat: use24Hour,
            textScaler: textSize == AppTextSize.standard
                ? media.textScaler
                : AppTextScaler(media.textScaler, textSize.multiplier),
          ),
          child: DefaultTextStyle(
            style: CupertinoTheme.of(context).textTheme.textStyle
                .copyWith(decoration: TextDecoration.none),
            child: child!,
          ),
        );
      },
      home: _StartupGate(initialization: initialization),
    );
  }
}

class _StartupGate extends StatefulWidget {
  const _StartupGate({required this.initialization});

  final Future<void> initialization;

  @override
  State<_StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<_StartupGate> {
  bool _introFinished = false;

  void _finishIntro() => setState(() => _introFinished = true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: widget.initialization,
      builder: (context, snapshot) => Consumer(
        builder: (context, ref, _) {
          if (snapshot.hasError) {
            return _AuthStatus(
              child: Text(AppStrings.of(context).firebaseStartupError),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            final session = ref.watch(authSessionProvider);
            if (session.hasError) {
              return _AuthStatus(child: Text(AppStrings.of(context).authError));
            }
            if (_introFinished && session.hasValue) {
              final uid = session.requireValue;
              return uid == null
                  ? const LoginScreen()
                  : AppointmentShell(key: ValueKey(uid), uid: uid);
            }
          }

          return AppSplashScreen(onFinished: _finishIntro);
        },
      ),
    );
  }
}

class _AuthStatus extends StatelessWidget {
  const _AuthStatus({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.large),
            child: child,
          ),
        ),
      ),
    );
  }
}
