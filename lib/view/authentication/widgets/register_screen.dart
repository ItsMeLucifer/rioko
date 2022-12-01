import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/color_palette.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/components/button.dart';
import 'package:rioko/view/components/text_field.dart';

class RegisterScreen extends ConsumerWidget {
  RegisterScreen({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseVM = ref.watch(baseProvider);
    final authVM = ref.watch(authenticationProvider);
    return Column(
      children: [
        RiokoTextField(
          controller: nameController,
          labelText: 'Name',
          sufixIconData: Icons.person,
        ),
        RiokoTextField(
          controller: emailController,
          labelText: 'Email',
          sufixIconData: Icons.mail,
        ),
        RiokoTextField(
          controller: passwordController,
          obscureText: true,
          labelText: 'Password',
          sufixIconData: Icons.key,
        ),
        RiokoButton(
          text: 'Register',
          onPressed: () => baseVM.register(
            context,
            email: emailController.text,
            password: passwordController.text,
          ),
          icon: Icons.create,
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            authVM.toggleAuthenticationPageStatus();
          },
          child: RichText(
            text: TextSpan(
              text: "Already have an account? ",
              style:
                  Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 13),
              children: <TextSpan>[
                TextSpan(
                  text: 'Login!',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: ColorPalette.cyclamen,
                        fontSize: 13,
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
