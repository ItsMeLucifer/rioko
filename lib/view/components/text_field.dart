import 'package:flutter/material.dart';

class RiokoTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool obscureText;
  final String? labelText;
  final bool enabled;
  final IconData? sufixIconData;
  final Color accentColor;
  final Color? fillColor;
  final double height;
  final Function()? onPressedSuffixIcon;
  final String prefix;
  final FocusNode? focusNode;
  const RiokoTextField({
    Key? key,
    required this.controller,
    this.onChanged,
    this.obscureText = false,
    this.labelText,
    this.onSubmitted,
    this.enabled = true,
    this.sufixIconData,
    this.fillColor,
    this.accentColor = Colors.white,
    this.height = 50,
    this.onPressedSuffixIcon,
    this.prefix = '',
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Stack(
        children: [
          TextFormField(
            focusNode: focusNode,
            enabled: enabled,
            controller: controller,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            obscureText: obscureText,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: accentColor),
            decoration: InputDecoration(
              labelText: labelText,
              contentPadding: const EdgeInsets.all(10.0),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: accentColor),
              focusColor: accentColor,
              isDense: true,
              filled: true,
              fillColor: fillColor ?? Theme.of(context).colorScheme.primary,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              prefix: prefix == '' ? null : Text('$prefix: '),
              prefixStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: accentColor,
                  ),
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: onPressedSuffixIcon,
              child: Icon(
                sufixIconData,
                color: accentColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
