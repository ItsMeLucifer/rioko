import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:rioko/common/debug_utils.dart';
import 'package:rioko/common/dialogs/yes_no_dialog.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/components/button.dart';
import 'package:rioko/view/components/text_field.dart';

class AddNewPlace extends ConsumerWidget {
  final bool edit;
  AddNewPlace({Key? key, this.edit = false}) : super(key: key);

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
    final kilometers = geolocationVM.getDistanceInKilometers(
        addNewPlaceVM.place.origin, addNewPlaceVM.place.destination);
    DebugUtils.printInfo(addNewPlaceVM.place.toString());
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: FractionallySizedBox(
        heightFactor: 0.97,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  Text(
                    "${edit ? 'EDIT' : 'NEW'} PLACE",
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          fontFamily: 'CeasarDressing',
                          color: Colors.black,
                        ),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                  RiokoTextField(
                    labelText: addNewPlaceVM.place.title == ''
                        ? ' Title'
                        : addNewPlaceVM.place.title,
                    controller: titleTextController,
                    prefix: 'Title',
                  ),
                  RiokoTextField(
                    enabled: addNewPlaceVM.place.origin == null,
                    onSubmitted: (value) =>
                        addNewPlaceVM.onSubmittedOrigin(value, ref),
                    labelText: addNewPlaceVM.originPlacemark == null
                        ? 'Origin'
                        : geolocationVM.getAddressFromPlacemark(
                            addNewPlaceVM.originPlacemark!),
                    controller: originTextController,
                    prefix: 'Origin',
                    sufixIconData: Icons.edit,
                    onPressedSuffixIcon: () {
                      addNewPlaceVM.place =
                          addNewPlaceVM.place.copyWith(origin: null);
                      addNewPlaceVM.originPlacemark = null;
                      originTextController.clear();
                    },
                  ),
                  RiokoTextField(
                    enabled: addNewPlaceVM.place.destination == null,
                    onSubmitted: (value) =>
                        addNewPlaceVM.onSubmittedDestination(value, ref),
                    labelText: addNewPlaceVM.destinationPlacemark == null
                        ? 'Destination'
                        : geolocationVM.getAddressFromPlacemark(
                            addNewPlaceVM.destinationPlacemark!),
                    controller: destinationTextController,
                    prefix: 'Destination',
                    sufixIconData: Icons.edit,
                    onPressedSuffixIcon: () {
                      addNewPlaceVM.place =
                          addNewPlaceVM.place.copyWith(destination: null);
                      addNewPlaceVM.destinationPlacemark = null;
                    },
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    width: double.infinity,
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          const TextSpan(
                            text: 'Distance: ',
                          ),
                          TextSpan(
                            text: '$kilometers',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const TextSpan(text: ' km'),
                        ],
                      ),
                    ),
                  ),
                  RiokoTextField(
                    enabled: addNewPlaceVM.place.destination == null,
                    onSubmitted: (value) =>
                        addNewPlaceVM.onSubmittedDestination(value, ref),
                    labelText: 'Description',
                    controller: descriptionTextController,
                    prefix: 'Description',
                    maxLines: null,
                    height: null,
                    maxHeight: 100,
                    keyboardType: TextInputType.multiline,
                  ),
                  const Expanded(flex: 8, child: SizedBox()),
                  SizedBox(
                    width: 150,
                    child: RiokoButton(
                      onPressed: () {
                        if ((addNewPlaceVM.place.origin == null &&
                                originTextController.text == '') ||
                            (addNewPlaceVM.place.destination == null &&
                                destinationTextController.text == '')) {
                          MotionToast.info(
                            title: Text(
                              "Provide all informations",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            description: const Text(
                              'You must specify origin and destination!',
                            ),
                            position: MotionToastPosition.top,
                            animationType: AnimationType.fromTop,
                            enableAnimation: true,
                          ).show(
                            context,
                          );
                        }
                        addNewPlaceVM.saveNewPlace(
                          context,
                          ref,
                          titleText: titleTextController.text,
                          originText: originTextController.text,
                          destinationText: destinationTextController.text,
                          kilometers: kilometers,
                          descriptionText: descriptionTextController.text,
                        );
                      },
                      icon: Icons.add,
                    ),
                  ),
                  const Expanded(flex: 4, child: SizedBox()),
                ],
              ),
            ),
            Positioned(
              right: 10.0,
              top: 10.0,
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => YesNoDialog(
                      title:
                          'Are you sure to delete ${addNewPlaceVM.place.title}?',
                      onPressedYes: () {
                        addNewPlaceVM.onPressedRemovePlace(context, ref);
                      },
                    ),
                  );
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
