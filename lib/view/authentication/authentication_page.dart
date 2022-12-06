import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/authentication/widgets/login_screen.dart';
import 'package:rioko/view/authentication/widgets/register_screen.dart';
import 'package:rioko/view/components/app_logo.dart';
import 'package:rioko/viewmodel/firebase/authentication_view_model.dart';

class AuthenticationPage extends ConsumerWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authVM = ref.watch(authenticationProvider);

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              flex: 2,
              child: SizedBox(),
            ),
            const AppLogo(),
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            authVM.authenticationPageStatus == AuthenticationPageStatus.login
                ? LoginScreen()
                : RegisterScreen(),
            const Expanded(
              flex: 3,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
