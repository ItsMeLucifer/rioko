import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/color_palette.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/components/button.dart';
import 'package:rioko/view/components/text_field.dart';
import 'package:rioko/viewmodel/firebase/authentication_view_model.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseVM = ref.watch(baseProvider);
    final authVM = ref.watch(authenticationProvider);
    return Column(
      children: [
        RiokoTextField(
          controller: emailController,
          labelText: 'Email',
          sufixIconData: Icons.mail,
          prefix: 'Email',
        ),
        RiokoTextField(
          controller: passwordController,
          obscureText: true,
          labelText: 'Password',
          sufixIconData: Icons.key,
          prefix: 'Password',
        ),
        const SizedBox(height: 10.0),
        RiokoButton(
          text: 'Login',
          onPressed: () => baseVM.login(
            context,
            email: emailController.text,
            password: passwordController.text,
          ),
          icon: Icons.login,
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            authVM.toggleAuthenticationPageStatus();
          },
          child: RichText(
            text: TextSpan(
              text: "Don't have an account? ",
              style:
                  Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 13),
              children: <TextSpan>[
                TextSpan(
                  text: 'Register!',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: ColorPalette.cyclamen,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
