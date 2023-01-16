import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:rioko/common/dialogs/yes_no_dialog.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/components/button.dart';
import 'package:rioko/view/components/text_field.dart';

class AddNewTrip extends ConsumerWidget {
  final bool edit;
  AddNewTrip({Key? key, this.edit = false}) : super(key: key);

  final TextEditingController destinationTextController =
      TextEditingController();
  final TextEditingController originTextController = TextEditingController();
  static TextEditingController titleTextController = TextEditingController();
  static TextEditingController descriptionTextController =
      TextEditingController();

  static FocusNode originFocusNode = FocusNode();
  static FocusNode destinationFocusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geolocationVM = ref.watch(geolocationProvider);
    final addNewTripVM = ref.watch(addNewTripProvider);
    final kilometers = geolocationVM.getDistanceInKilometers(
        addNewTripVM.trip.origin, addNewTripVM.trip.destination);
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
                    "${edit ? 'EDIT' : 'NEW'} TRIP",
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          fontFamily: 'CeasarDressing',
                          color: Colors.black,
                        ),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                  RiokoTextField(
                    labelText: addNewTripVM.trip.title == ''
                        ? ' Title'
                        : addNewTripVM.trip.title,
                    controller: titleTextController,
                    prefix: 'Title',
                  ),
                  RiokoTextField(
                    focusNode: originFocusNode,
                    enabled: addNewTripVM.trip.origin == null,
                    onSubmitted: (value) => addNewTripVM.onSubmittedOrigin(
                      context,
                      value: value,
                      ref: ref,
                    ),
                    labelText: addNewTripVM.originPlacemark == null
                        ? 'Origin'
                        : geolocationVM.getAddressFromPlacemark(
                            addNewTripVM.originPlacemark!,
                          ),
                    controller: originTextController,
                    prefix: 'Origin',
                    sufixIconData: Icons.edit,
                    onPressedSuffixIcon: () {
                      addNewTripVM.trip =
                          addNewTripVM.trip.copyWith(origin: null);
                      addNewTripVM.originPlacemark = null;
                      originTextController.clear();
                    },
                  ),
                  RiokoTextField(
                    focusNode: destinationFocusNode,
                    enabled: addNewTripVM.trip.destination == null,
                    onSubmitted: (value) => addNewTripVM.onSubmittedDestination(
                      context,
                      value: value,
                      ref: ref,
                    ),
                    labelText: addNewTripVM.destinationPlacemark == null
                        ? 'Destination'
                        : geolocationVM.getAddressFromPlacemark(
                            addNewTripVM.destinationPlacemark!),
                    controller: destinationTextController,
                    prefix: 'Destination',
                    sufixIconData: Icons.edit,
                    onPressedSuffixIcon: () {
                      addNewTripVM.trip =
                          addNewTripVM.trip.copyWith(destination: null);
                      addNewTripVM.destinationPlacemark = null;
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
                        if ((addNewTripVM.trip.origin == null &&
                                originTextController.text == '') ||
                            (addNewTripVM.trip.destination == null &&
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
                        addNewTripVM.saveNewTrip(
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
            if (edit)
              Positioned(
                right: 10.0,
                top: 10.0,
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => YesNoDialog(
                        title:
                            'Are you sure to delete ${addNewTripVM.trip.title}?',
                        onPressedYes: () {
                          addNewTripVM.onPressedRemoveTrip(context, ref);
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
