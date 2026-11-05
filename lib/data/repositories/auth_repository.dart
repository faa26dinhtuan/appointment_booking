import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  Stream<String?> sessionChanges() =>
      _auth.authStateChanges().map((user) => user?.uid);

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> register(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      if (error.code != 'user-not-found') rethrow;
    }
  }

  Stream<String?> displayNameChanges(String uid) => _auth.userChanges().map(
    (user) => user?.uid == uid ? user?.displayName : null,
  );

  Future<void> updateDisplayName(String uid, String name) async {
    final user = _auth.currentUser;
    if (user == null || user.uid != uid) {
      throw FirebaseAuthException(code: 'user-token-expired');
    }
    await user.updateDisplayName(name.isEmpty ? null : name);
  }

  Future<void> changePassword({
    required String uid,
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    final email = user?.email;
    if (user == null || user.uid != uid || email == null) {
      throw FirebaseAuthException(code: 'user-token-expired');
    }

    await user.reauthenticateWithCredential(
      EmailAuthProvider.credential(email: email, password: currentPassword),
    );
    if (_auth.currentUser?.uid != uid) {
      throw FirebaseAuthException(code: 'user-token-expired');
    }
    await user.updatePassword(newPassword);
  }

  Future<void> signOut() => _auth.signOut();
}
