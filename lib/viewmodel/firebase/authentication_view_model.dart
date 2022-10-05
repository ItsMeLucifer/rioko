import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/service/authentication_service.dart';
import 'package:rioko/view/components/dialogs.dart';

class AuthenticationViewModel extends ChangeNotifier {
  String _exceptionMessage = '';
  String get exceptionMessage => _exceptionMessage;
  set exceptionMessage(String exceptionMessage) {
    _exceptionMessage = exceptionMessage;
    notifyListeners();
  }

  final AuthenticationService _authenticationService = AuthenticationService();
  Future<void> login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      var result = await _authenticationService.loginWithEmail(
        email: email,
        password: password,
      );
      if (result) {
        Navigator.of(context).pushReplacementNamed(RouteNames.map);
      }
      return;
    } on FirebaseAuthException catch (e) {
      String content = 'Unknown error';
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
  }

  Future<void> signUp(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      var result = await _authenticationService.signUpWithEmail(
        email: email,
        password: password,
      );
      if (result) {
        Navigator.of(context).pushReplacementNamed(RouteNames.map);
      }
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        exceptionMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        exceptionMessage = 'The account already exists for that email.';
      }
    } catch (e) {
      exceptionMessage = 'Unknown error';
    }
  }
}
