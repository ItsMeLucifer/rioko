import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool obscureText;
  final String? labelText;
  final bool? enabled;
  final IconData? sufixIconData;
  final Color accentColor;
  final Color? fillColor;
  const CustomTextField({
    Key? key,
    required this.controller,
    this.onChanged,
    this.obscureText = false,
    this.labelText,
    this.onSubmitted,
    this.enabled,
    this.sufixIconData,
    this.fillColor,
    this.accentColor = Colors.white54,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        obscureText: obscureText,
        style:
            Theme.of(context).textTheme.bodyText1?.copyWith(color: accentColor),
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: const EdgeInsets.all(10.0),
          suffixIcon: Icon(sufixIconData, color: accentColor),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: accentColor),
          focusColor: accentColor,
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
