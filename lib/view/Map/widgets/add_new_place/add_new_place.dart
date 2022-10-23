import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/main.dart';
import 'package:rioko/model/travel_place.dart';
import 'package:rioko/view/components/text_field.dart';
import 'package:rioko/view/map/widgets/add_new_place/add_new_place_text_field.dart';

class AddNewPlace extends ConsumerWidget {
  AddNewPlace({Key? key}) : super(key: key);

  final TextEditingController destinationTextController =
      TextEditingController();
  final TextEditingController originTextController = TextEditingController();
  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController descriptionTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geolocationVM = ref.watch(geolocationProvider);
    final addNewPlaceVM = ref.watch(addNewPlaceProvider);
    final kilometers = geolocationVM.getDistanceInKilometers(
        addNewPlaceVM.origin, addNewPlaceVM.destination);
    return Column(
      children: [
        AddNewPlaceTextField(
          prefix: 'Title: ',
          textField: CustomTextField(
            hintText:
                addNewPlaceVM.title == '' ? ' Title' : addNewPlaceVM.title,
            controller: titleTextController,
            onChanged: (title) {
              addNewPlaceVM.title = title;
            },
          ),
        ),
        AddNewPlaceTextField(
          textField: CustomTextField(
            enabled: addNewPlaceVM.origin == null,
            onSubmitted: (value) => _onSubmittedOrigin(value, ref),
            hintText: addNewPlaceVM.originPlacemark == null
                ? 'Where did you start?'
                : geolocationVM
                    .getAddressFromPlacemark(addNewPlaceVM.originPlacemark!),
            controller: originTextController,
          ),
          prefix: 'From: ',
          onPressedEdit: () {
            addNewPlaceVM.origin = null;
            addNewPlaceVM.originPlacemark = null;
          },
        ),
        AddNewPlaceTextField(
          textField: CustomTextField(
            enabled: addNewPlaceVM.destination == null,
            onSubmitted: (value) => _onSubmittedDestination(value, ref),
            hintText: addNewPlaceVM.destinationPlacemark == null
                ? 'Where did you travel?'
                : geolocationVM.getAddressFromPlacemark(
                    addNewPlaceVM.destinationPlacemark!),
            controller: destinationTextController,
          ),
          prefix: 'To: ',
          onPressedEdit: () {
            addNewPlaceVM.destination = null;
            addNewPlaceVM.destinationPlacemark = null;
          },
        ),
        AddNewPlaceTextField(
          prefix: 'Distance: $kilometers km',
        ),
        TextButton(
          onPressed: () {
            final authVM = ref.read(authenticationProvider);
            final mapVM = ref.read(mapProvider);
            _onSubmittedOrigin(originTextController.text, ref);
            _onSubmittedOrigin(destinationTextController.text, ref);
            if (authVM.currentUser?.id == null ||
                addNewPlaceVM.travelPlace == null ||
                addNewPlaceVM.origin == null ||
                addNewPlaceVM.destination == null) return;
            addNewPlaceVM.travelPlace = addNewPlaceVM.travelPlace?.copyWith(
              originCoordinates: addNewPlaceVM.origin,
              destinationCoordinates: addNewPlaceVM.destination,
              title: addNewPlaceVM.title,
              description: addNewPlaceVM.description,
              kilometers: kilometers,
            );
            _addNewTravelPlaceToFirebase(context, ref);
            mapVM.addTravelPlace(addNewPlaceVM.travelPlace!);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _addNewTravelPlaceToFirebase(BuildContext context, WidgetRef ref) async {
    final firestoreDBVM = ref.read(firestoreDatabaseProvider);
    final addNewPlaceVM = ref.read(addNewPlaceProvider);
    final authVM = ref.read(authenticationProvider);
    final response = await firestoreDBVM.addNewPlace(
        addNewPlaceVM.travelPlace!, authVM.currentUser!.id);
    if (response) Navigator.of(context).pop();
  }

  void _onSubmittedOrigin(String value, WidgetRef ref) async {
    final geolocationVM = ref.read(geolocationProvider);
    final addNewPlaceVM = ref.read(addNewPlaceProvider);
    if (value.length > 3) {
      await geolocationVM.getLocationsFromAddress(value).then((latLng) {
        if (latLng != null) {
          geolocationVM.getPlacemarkFromCoordinates(latLng).then((placemark) {
            if (placemark != null) {
              addNewPlaceVM.originPlacemark = placemark;
            }
          });
          addNewPlaceVM.origin = latLng;
        }
      });
    }
  }

  void _onSubmittedDestination(String value, WidgetRef ref) async {
    final geolocationVM = ref.read(geolocationProvider);
    final mapVM = ref.read(mapProvider);
    final addNewPlaceVM = ref.read(addNewPlaceProvider);
    if (value.length > 3) {
      await geolocationVM.getLocationsFromAddress(value).then((latLng) {
        if (latLng != null) {
          geolocationVM.getPlacemarkFromCoordinates(latLng).then((placemark) {
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
  }
}
