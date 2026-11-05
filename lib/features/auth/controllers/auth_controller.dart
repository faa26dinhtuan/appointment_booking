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

final displayNameProvider = StreamProvider.autoDispose.family<String?, String>(
  (ref, uid) => ref.watch(authControllerProvider).displayNameChanges(uid),
);

String authErrorMessage(Object error, AppStrings strings) {
  if (error is! FirebaseAuthException) return strings.authError;

  return switch (error.code) {
    'network-request-failed' => strings.authNetworkError,
    'too-many-requests' => strings.authRateLimited,
    'invalid-email' => strings.emailInvalid,
    'invalid-credential' ||
    'wrong-password' ||
    'user-not-found' => strings.authInvalidCredentials,
    'email-already-in-use' => strings.authEmailInUse,
    'user-disabled' => strings.authAccountDisabled,
    'weak-password' ||
    'password-does-not-meet-requirements' => strings.authWeakPassword,
    _ => strings.authError,
  };
}
