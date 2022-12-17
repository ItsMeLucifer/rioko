import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/main.dart';
import 'package:rioko/model/travel_place.dart';

class AddNewPlaceViewModel extends ChangeNotifier {
  TravelPlace _place = TravelPlace.newPlace;
  TravelPlace get place => _place;
  set place(TravelPlace place) {
    _place = place;
    notifyListeners();
  }

  Placemark? _destinationPlacemark;
  Placemark? get destinationPlacemark => _destinationPlacemark;
  set destinationPlacemark(Placemark? placemark) {
    _destinationPlacemark = placemark;
    notifyListeners();
  }

  Placemark? _originPlacemark;
  Placemark? get originPlacemark => _originPlacemark;
  set originPlacemark(Placemark? placemark) {
    _originPlacemark = placemark;
    notifyListeners();
  }

  Future onSubmittedOrigin(String value, WidgetRef ref) async {
    final geolocationVM = ref.read(geolocationProvider);
    if (value.length > 3) {
      await geolocationVM.getLocationsFromAddress(value).then((latLng) {
        if (latLng != null) {
          geolocationVM.getPlacemarkFromCoordinates(latLng).then((placemark) {
            if (placemark != null) {
              originPlacemark = placemark;
            }
          });
          place = place.copyWith(origin: latLng);
        }
      });
    }
  }

  Future onSubmittedDestination(String value, WidgetRef ref) async {
    final geolocationVM = ref.read(geolocationProvider);
    final mapVM = ref.read(mapProvider);
    if (value.length > 3) {
      await geolocationVM.getLocationsFromAddress(value).then((latLng) {
        if (latLng != null) {
          geolocationVM.getPlacemarkFromCoordinates(latLng).then((placemark) {
            if (placemark != null) {
              destinationPlacemark = placemark;
            }
          });
          mapVM.mapMoveTo(
            position: latLng,
          );
          place = place.copyWith(destination: latLng);
        }
      });
    }
  }

  void saveNewPlace(
    BuildContext context,
    WidgetRef ref, {
    required String titleText,
    required String originText,
    required String destinationText,
    required double? kilometers,
    required String descriptionText,
  }) async {
    final authVM = ref.read(authenticationProvider);
    final mapVM = ref.read(mapProvider);
    final baseVM = ref.read(baseProvider);
    if (place.origin == null) {
      await onSubmittedOrigin(originText, ref);
    }
    if (place.destination == null) {
      await onSubmittedDestination(destinationText, ref);
    }

    if (authVM.currentUser?.id == null) {
      Navigator.of(context).pushReplacementNamed(RouteNames.authentication);
      return;
    }
    if (place.origin == null || place.destination == null || kilometers == 0) {
      return;
    }
    place = place.copyWith(
      title: titleText,
      description: descriptionText,
      kilometers: kilometers!,
    );
    baseVM.addNewTravelPlaceToFirebase(context);
    mapVM.addTravelPlace(place);
  }

  void setPlaceToEdit(TravelPlace place, WidgetRef ref) async {
    final geolocationVM = ref.read(geolocationProvider);
    this.place = place;
    if (place.origin != null) {
      originPlacemark =
          await geolocationVM.getPlacemarkFromCoordinates(place.origin!);
    }
    if (place.destination != null) {
      destinationPlacemark =
          await geolocationVM.getPlacemarkFromCoordinates(place.destination!);
    }
  }

  Future onPressedRemovePlace(BuildContext context, WidgetRef ref) async {
    final firestoreVM = ref.read(firestoreDatabaseProvider);
    final authVM = ref.read(authenticationProvider);
    //Remove from the database
    String? response;
    if (authVM.currentUser != null) {
      response = await firestoreVM.removePlace(
        place.id,
        authVM.currentUser!.id,
      );
    }
    if (response != null) {
      MotionToast.error(
        title: const Text("Error"),
        description: Text(
          response,
        ),
        position: MotionToastPosition.top,
        animationType: AnimationType.fromTop,
      ).show(
        context,
      );
      return;
    }
    //Remove locally
    final mapVM = ref.read(mapProvider);
    mapVM.removePlaceLocally(place.id);
    Navigator.of(context).popUntil(ModalRoute.withName(RouteNames.map));
  }
}
