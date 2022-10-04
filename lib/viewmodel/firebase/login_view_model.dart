import 'package:flutter/material.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/service/authentication_service.dart';
import 'package:rioko/viewmodel/base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthenticationService _authenticationService = AuthenticationService();

  Future login(
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
        // await _dialogService.showDialog(
        //   title: 'Login Failure',
        //   description: 'General login failure. Please try again later',
        // );
      }
    } else {
      // await _dialogService.showDialog(
      //   title: 'Login Failure',
      //   description: result,
      // );
    }
  }
}
