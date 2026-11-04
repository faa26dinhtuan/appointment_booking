import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/appointments/screens/appointment_shell.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/settings/controllers/locale_controller.dart';
import 'firebase_options.dart';
import 'l10n/app_strings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final locale = await LocaleController.load();
  runApp(
    ProviderScope(
      overrides: [initialLocaleProvider.overrideWithValue(locale)],
      child: MyApp(initialization: _initializeFirebase()),
    ),
  );
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends ConsumerWidget {
  const MyApp({required this.initialization, super.key});

  final Future<void> initialization;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppStrings.of(context).appName,
      locale: ref.watch(localeControllerProvider),
      supportedLocales: AppStrings.supportedLocales,
      localizationsDelegates: const [
        AppStrings.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      theme: AppTheme.light,
      builder: (context, child) => DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle
            .copyWith(decoration: TextDecoration.none),
        child: child!,
      ),
      home: FutureBuilder<void>(
        future: initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _AuthStatus(
              child: Text(AppStrings.of(context).firebaseStartupError),
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const _AuthStatus(child: CupertinoActivityIndicator());
          }
          return const _AuthGate();
        },
      ),
    );
  }
}

class _AuthGate extends ConsumerWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(authSessionProvider)
        .when(
          data: (uid) => uid == null
              ? const LoginScreen()
              : AppointmentShell(key: ValueKey(uid), uid: uid),
          loading: () => const _AuthStatus(child: CupertinoActivityIndicator()),
          error: (_, _) =>
              _AuthStatus(child: Text(AppStrings.of(context).authError)),
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
