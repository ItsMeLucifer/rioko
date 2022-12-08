import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
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
    place = place.copyWith(title: titleText, description: descriptionText);
    baseVM.addNewTravelPlaceToFirebase(context);
    mapVM.addTravelPlace(place);
  }
}
