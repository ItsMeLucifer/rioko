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
        CustomTextField(
          controller: nameController,
          labelText: 'Name',
          fillColor: ColorPalette.babyBlue,
          sufixIconData: Icons.person,
        ),
        CustomTextField(
          controller: emailController,
          labelText: 'Email',
          fillColor: ColorPalette.babyBlue,
          sufixIconData: Icons.mail,
        ),
        CustomTextField(
          controller: passwordController,
          obscureText: true,
          labelText: 'Password',
          fillColor: ColorPalette.babyBlue,
          sufixIconData: Icons.key,
        ),
        CustomButton(
          text: 'Register',
          onPressed: () => baseVM.register(
            context,
            email: emailController.text,
            password: passwordController.text,
          ),
          icon: Icons.create,
          fillColor: ColorPalette.cottonCandy,
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
