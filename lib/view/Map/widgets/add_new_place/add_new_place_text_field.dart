import 'package:flutter/material.dart';
import 'package:rioko/view/components/text_field.dart';

class AddNewPlaceTextField extends StatelessWidget {
  final CustomTextField? textField;
  final Function? onPressedEdit;
  final String prefix;
  const AddNewPlaceTextField({
    Key? key,
    this.textField,
    this.onPressedEdit,
    required this.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
              flex: textField == null ? 6 : 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(prefix),
              )),
          if (textField != null) Expanded(flex: 5, child: textField!),
          Expanded(
            child: onPressedEdit != null
                ? IconButton(
                    onPressed: onPressedEdit as Function(),
                    icon: const Icon(Icons.edit),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
