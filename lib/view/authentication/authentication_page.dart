import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rioko/common/color_palette.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/components/text_field.dart';

class AuthenticationPage extends ConsumerWidget {
  AuthenticationPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authVM = ref.watch(authenticationProvider);
    final baseVM = ref.watch(baseProvider);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                      width: 80,
                      height: 70,
                      child: Image.asset('assets/icons/travel.png')),
                ),
                Text(
                  'Rioko',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(),
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
              fillColor: ColorPalette.skyBlue,
              sufixIconData: Icons.key,
            ),
            IconButton(
              onPressed: () {
                baseVM.login(
                  context,
                  email: emailController.text,
                  password: passwordController.text,
                );
              },
              icon: const Icon(Icons.login),
            ),
            IconButton(
              onPressed: () {
                baseVM.register(
                  context,
                  email: emailController.text,
                  password: passwordController.text,
                );
              },
              icon: const Icon(Icons.create),
            ),
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
