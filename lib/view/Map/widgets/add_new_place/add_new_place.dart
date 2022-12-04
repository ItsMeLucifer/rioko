import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/color_palette.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/components/button.dart';
import 'package:rioko/view/components/text_field.dart';

class AddNewPlace extends ConsumerWidget {
  AddNewPlace({Key? key}) : super(key: key);

  final TextEditingController destinationTextController =
      TextEditingController();
  final TextEditingController originTextController = TextEditingController();
  static TextEditingController titleTextController = TextEditingController();
  final TextEditingController descriptionTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geolocationVM = ref.watch(geolocationProvider);
    final addNewPlaceVM = ref.watch(addNewPlaceProvider);
    final baseVM = ref.watch(baseProvider);
    final kilometers = geolocationVM.getDistanceInKilometers(
        addNewPlaceVM.origin, addNewPlaceVM.destination);

    return Column(
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        RiokoTextField(
          labelText: addNewPlaceVM.title == '' ? ' Title' : addNewPlaceVM.title,
          controller: titleTextController,
          prefix: 'Title',
        ),
        RiokoTextField(
          enabled: addNewPlaceVM.origin == null,
          onSubmitted: (value) => baseVM.addNewPlaceOnSubmittedOrigin(value),
          labelText: addNewPlaceVM.originPlacemark == null
              ? 'Where did you start?'
              : geolocationVM
                  .getAddressFromPlacemark(addNewPlaceVM.originPlacemark!),
          controller: originTextController,
          prefix: 'Origin',
          sufixIconData: Icons.edit,
          onPressedSuffixIcon: () {
            addNewPlaceVM.origin = null;
            addNewPlaceVM.originPlacemark = null;
            originTextController.clear();
          },
        ),
        RiokoTextField(
          enabled: addNewPlaceVM.destination == null,
          onSubmitted: (value) =>
              baseVM.addNewPlaceOnSubmittedDestination(value),
          labelText: addNewPlaceVM.destinationPlacemark == null
              ? 'Where did you travel?'
              : geolocationVM
                  .getAddressFromPlacemark(addNewPlaceVM.destinationPlacemark!),
          controller: destinationTextController,
          prefix: 'Destination',
          sufixIconData: Icons.edit,
          onPressedSuffixIcon: () {
            addNewPlaceVM.destination = null;
            addNewPlaceVM.destinationPlacemark = null;
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          width: double.infinity,
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyText2,
              children: [
                const TextSpan(
                  text: 'Distance: ',
                ),
                TextSpan(
                  text: '$kilometers',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.cyclamen,
                        fontSize: 16,
                      ),
                ),
                const TextSpan(text: ' km'),
              ],
            ),
          ),
        ),
        const Expanded(flex: 2, child: SizedBox()),
        SizedBox(
          width: 150,
          child: RiokoButton(
            onPressed: () => addNewPlaceVM.saveNewPlace(
              context,
              ref,
              titleText: titleTextController.text,
              originText: originTextController.text,
              destinationText: destinationTextController.text,
              kilometers: kilometers,
            ),
            icon: Icons.add,
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }
}
