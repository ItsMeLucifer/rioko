import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool obscureText;
  final String? hintText;
  const CustomTextField({
    Key? key,
    required this.controller,
    this.onChanged,
    this.obscureText = false,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
