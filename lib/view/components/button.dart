import 'package:flutter/material.dart';

class RiokoButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Color? fillColor;
  final Color accentColor;
  final Function()? onPressed;
  const RiokoButton({
    Key? key,
    required this.onPressed,
    this.text,
    this.icon,
    this.fillColor,
    this.accentColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const SizedBox filler = SizedBox();
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: fillColor ??
                Theme.of(context).buttonTheme.colorScheme?.background,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: accentColor),
              const SizedBox(width: 10),
              if (text != null)
                Text(
                  text!,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: accentColor),
                ),
            ],
          ),
        ));
  }
}
