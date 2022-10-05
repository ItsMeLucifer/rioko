import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/main.dart';

class AuthenticationPage extends ConsumerWidget {
  AuthenticationPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapVM = ref.watch(mapServiceProvider);
    final authVM = ref.watch(authenticationProvider);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            authVM.exceptionMessage,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          TextFormField(
            controller: emailController,
            onChanged: (value) {
              authVM.exceptionMessage = '';
            },
          ),
          TextFormField(
            controller: passwordController,
            onChanged: (value) {
              authVM.exceptionMessage = '';
            },
          ),
          IconButton(
            onPressed: () {
              authVM.login(
                context,
                email: emailController.text,
                password: passwordController.text,
              );
            },
            icon: const Icon(Icons.login),
          ),
          IconButton(
            onPressed: () {
              authVM.signUp(
                context,
                email: emailController.text,
                password: passwordController.text,
              );
            },
            icon: const Icon(Icons.create),
          ),
        ],
      ),
    );
  }
}
