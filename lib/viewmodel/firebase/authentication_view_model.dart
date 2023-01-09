import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:rioko/model/user.dart';
import 'package:flutter/material.dart';
import 'package:rioko/service/authentication_service.dart';

enum AuthenticationPageStatus {
  login,
  register,
}

class AuthenticationViewModel extends ChangeNotifier {
  AuthenticationPageStatus _authenticationPageStatus =
      AuthenticationPageStatus.login;
  AuthenticationPageStatus get authenticationPageStatus =>
      _authenticationPageStatus;
  void toggleAuthenticationPageStatus() {
    if (_authenticationPageStatus == AuthenticationPageStatus.login) {
      _authenticationPageStatus = AuthenticationPageStatus.register;
    } else {
      _authenticationPageStatus = AuthenticationPageStatus.login;
    }
    notifyListeners();
  }

  String _exceptionMessage = '';
  String get exceptionMessage => _exceptionMessage;
  set exceptionMessage(String exceptionMessage) {
    _exceptionMessage = exceptionMessage;
    notifyListeners();
  }

  User? _currentUser;
  User? get currentUser => _currentUser;
  set currentUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<bool> updateDisplayName(String displayName) async {
    try {
      await _authenticationService.updateDisplayName(displayName);
      return true;
    } catch (e) {}
    return false;
  }

  final AuthenticationService _authenticationService = AuthenticationService();
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      var user = await _authenticationService.loginWithEmail(
        email: email,
        password: password,
      );
      currentUser = User.fromFirebase(user);
      return true;
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        exceptionMessage = 'User not found.';
      } else if (e.code == 'wrong-password') {
        exceptionMessage = 'Wrong password';
      } else if (e.code == 'invalid-email') {
        exceptionMessage = 'Invalid email.';
      } else if (e.code == 'user-disabled') {
        exceptionMessage = 'The user has beed disabled.';
      }
    } catch (e) {
      exceptionMessage = 'Unknown error';
    }
    return false;
  }

  Future<bool> signUp({
    required String email,
    required String password,
  }) async {
    try {
      var user = await _authenticationService.signUpWithEmail(
        email: email,
        password: password,
      );
      currentUser = User.fromFirebase(user);
      return true;
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        exceptionMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        exceptionMessage = 'The account already exists for that email.';
      }
    } catch (e) {
      exceptionMessage = 'Unknown error';
    }
    return false;
  }
}
