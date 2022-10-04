import 'package:flutter/material.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/service/authentication_service.dart';
import 'package:rioko/viewmodel/base_model.dart';

class AuthenticationViewModel extends BaseModel {
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<void> login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    setBusy(true);

    var result = await _authenticationService.loginWithEmail(
      email: email,
      password: password,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        Navigator.of(context).pushReplacementNamed(RouteNames.map);
      } else {
        debugPrint('Login Failure - unauthenticated');
        // await _dialogService.showDialog(
        //   title: 'Login Failure',
        //   description: 'General login failure. Please try again later',
        // );
      }
    } else {
      debugPrint('Login Failure - unknown issue');
      // await _dialogService.showDialog(
      //   title: 'Login Failure',
      //   description: result,
      // );
    }
  }

  Future<void> signUp(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    setBusy(true);

    var result = await _authenticationService.signUpWithEmail(
      email: email,
      password: password,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        Navigator.of(context).pushReplacementNamed(RouteNames.map);
      } else {
        debugPrint('Sign up failure');
        // await _dialogService.showDialog(
        //   title: 'Sign Up Failure',
        //   description: 'General sign up failure. Please try again later',
        // );
      }
    } else {
      debugPrint('Sign up failure - unknown issue');
      // await _dialogService.showDialog(
      //   title: 'Sign Up Failure',
      //   description: result,
      // );
    }
  }
}
