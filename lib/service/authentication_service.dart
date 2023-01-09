import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class AuthenticationService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  Future<auth.User> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user!;
    } catch (e) {
      rethrow;
    }
  }

  Future<auth.User> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateDisplayName(String displayName) async {
    if (auth.FirebaseAuth.instance.currentUser != null) {
      try {
        await auth.FirebaseAuth.instance.currentUser!
            .updateDisplayName(displayName);
        return true;
      } catch (e) {
        rethrow;
      }
    }
    return false;
  }
}
