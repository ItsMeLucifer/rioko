import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/viewmodel/firebase/authentication_view_model.dart';
import 'package:rioko/viewmodel/geolocation/geolocation_view_model.dart';

class DataCompletionViewModel extends ChangeNotifier {
  final GeolocationViewModel geolocationVM;
  final AuthenticationViewModel authVM;

  DataCompletionViewModel({
    required this.geolocationVM,
    required this.authVM,
  });

  LatLng? _tempPosition;
  LatLng? get tempPosition => _tempPosition;
  set tempPosition(LatLng? position) {
    _tempPosition = position;
    notifyListeners();
  }

  Placemark? _tempPositionPlacemark = Placemark();
  Placemark? get tempPositionPlacemark => _tempPositionPlacemark;
  set tempPositionPlacemark(Placemark? placemark) {
    _tempPositionPlacemark = placemark;
    notifyListeners();
  }

  void setHomeAsCurrentPosition() async {
    geolocationVM.getCurrentPosition().then((currentPosition) async {
      if (currentPosition == null) return;
      tempPosition = currentPosition;
      await geolocationVM
          .getPlacemarkFromCoordinates(currentPosition)
          .then((placemark) {
        if (placemark != null) {
          tempPositionPlacemark = placemark;
        }
      });
      if (authVM.currentUser != null) {
        authVM.currentUser = authVM.currentUser!.copyWith(
          home: currentPosition,
          homeAddress: tempPositionPlacemark == null
              ? ''
              : geolocationVM.getAddressFromPlacemark(tempPositionPlacemark!),
        );
      }
    });
  }

  void onSubmittedHome(String value) async {
    if (value.length > 3) {
      await geolocationVM.getLocationsFromAddress(value).then((latLng) {
        if (latLng != null) {
          geolocationVM.getPlacemarkFromCoordinates(latLng).then((placemark) {
            if (placemark != null) {
              tempPositionPlacemark = placemark;
            }
          });
          tempPosition = latLng;
        }
      });
    }
  }
}
