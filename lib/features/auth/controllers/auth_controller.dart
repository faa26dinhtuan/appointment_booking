import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../l10n/app_strings.dart';

final authControllerProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(FirebaseAuth.instance),
);

final authSessionProvider = StreamProvider<String?>(
  (ref) => ref.watch(authControllerProvider).sessionChanges(),
);

String authErrorMessage(Object error) {
  if (error is! FirebaseAuthException) return AppStrings.authError;

  return switch (error.code) {
    'network-request-failed' => AppStrings.authNetworkError,
    'too-many-requests' => AppStrings.authRateLimited,
    'invalid-email' => AppStrings.emailInvalid,
    'invalid-credential' ||
    'wrong-password' ||
    'user-not-found' => AppStrings.authInvalidCredentials,
    'email-already-in-use' => AppStrings.authEmailInUse,
    'user-disabled' => AppStrings.authAccountDisabled,
    'weak-password' ||
    'password-does-not-meet-requirements' => AppStrings.authWeakPassword,
    _ => AppStrings.authError,
  };
}
