import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/appointments/screens/appointment_shell.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/screens/login_screen.dart';
import 'firebase_options.dart';
import 'l10n/app_strings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MyApp(initialization: _initializeFirebase())));
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({required this.initialization, super.key});

  final Future<void> initialization;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      locale: AppStrings.locale,
      supportedLocales: const [AppStrings.locale],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
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
            return const _AuthStatus(
              child: Text(AppStrings.firebaseStartupError),
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
          error: (_, _) => const _AuthStatus(child: Text(AppStrings.authError)),
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
