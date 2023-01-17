import 'package:flutter/material.dart';

class RiokoBackButton extends StatelessWidget {
  final BuildContext ctx;
  const RiokoBackButton(this.ctx, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(ctx).pop(),
      icon: const Icon(
        Icons.arrow_back_ios_new,
      ),
    );
  }
}
