import 'package:flutter/material.dart';
import 'package:rioko/view/components/button.dart';

class YesNoDialog extends StatelessWidget {
  final String title;
  final String description;
  final Function() onPressedYes;
  const YesNoDialog(
      {Key? key,
      required this.title,
      this.description = '',
      required this.onPressedYes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: Text(
        description,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      actions: [
        Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: RiokoButton(
                text: 'Yes',
                onPressed: () {
                  onPressedYes();
                  Navigator.of(context).pop();
                },
              ),
            ),
            Expanded(
              child: RiokoButton(
                text: 'No',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
