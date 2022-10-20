import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/main.dart';
import 'package:rioko/model/travel_place.dart';
import 'package:rioko/view/components/text_field.dart';

class AddNewPlace extends ConsumerWidget {
  AddNewPlace({Key? key}) : super(key: key);

  final TextEditingController destinationTextController =
      TextEditingController();
  final TextEditingController originTextController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authVM = ref.watch(authenticationProvider);
    final geolocationVM = ref.watch(geolocationProvider);
    final mapVM = ref.watch(mapProvider);
    final addNewPlaceVM = ref.watch(addNewPlaceProvider);
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text('From: '),
            )),
            Expanded(
              flex: 5,
              child: CustomTextField(
                enabled: addNewPlaceVM.origin == null,
                onSubmitted: (value) async {
                  if (value.length > 3) {
                    await geolocationVM
                        .getLocationsFromAddress(value)
                        .then((latLng) {
                      if (latLng != null) {
                        geolocationVM
                            .getPlacemarkFromCoordinates(latLng)
                            .then((placemark) {
                          if (placemark != null) {
                            addNewPlaceVM.originPlacemark = placemark;
                          }
                        });
                        addNewPlaceVM.origin = latLng;
                      }
                    });
                  }
                },
                hintText: addNewPlaceVM.originPlacemark == null
                    ? 'Where did you start?'
                    : geolocationVM.getAddressFromPlacemark(
                        addNewPlaceVM.originPlacemark!),
                controller: originTextController,
              ),
            ),
            IconButton(
              enableFeedback: addNewPlaceVM.origin != null,
              onPressed: () {
                addNewPlaceVM.origin = null;
                addNewPlaceVM.originPlacemark = null;
              },
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text('To: '),
            )),
            Expanded(
              flex: 5,
              child: CustomTextField(
                enabled: addNewPlaceVM.destination == null,
                onSubmitted: (value) async {
                  if (value.length > 3) {
                    await geolocationVM
                        .getLocationsFromAddress(value)
                        .then((latLng) {
                      if (latLng != null) {
                        geolocationVM
                            .getPlacemarkFromCoordinates(latLng)
                            .then((placemark) {
                          if (placemark != null) {
                            addNewPlaceVM.destinationPlacemark = placemark;
                          }
                        });
                        mapVM.mapMoveTo(
                          position: latLng,
                        );
                        addNewPlaceVM.destination = latLng;
                      }
                    });
                  }
                },
                hintText: addNewPlaceVM.destinationPlacemark == null
                    ? 'Where did you travel?'
                    : geolocationVM.getAddressFromPlacemark(
                        addNewPlaceVM.destinationPlacemark!),
                controller: destinationTextController,
              ),
            ),
            IconButton(
              enableFeedback: addNewPlaceVM.destination != null,
              onPressed: () {
                addNewPlaceVM.destination = null;
                addNewPlaceVM.destinationPlacemark = null;
              },
              icon: const Icon(Icons.edit),
            ),
            TextButton(
              onPressed: () {
                addNewPlaceVM.travelPlace = addNewPlaceVM.travelPlace!.copyWith(
                  originCoordinates: addNewPlaceVM.origin,
                  destinationCoordinates: addNewPlaceVM.destination,
                  title: titleController.text,
                  description: descriptionController.text,
                );
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ],
    );
  }
}
