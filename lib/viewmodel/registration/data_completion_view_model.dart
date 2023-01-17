import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:rioko/common/debug_utils.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/main.dart';

class DataCompletionViewModel extends ChangeNotifier {
  LatLng? _tempPosition;
  LatLng? get tempPosition => _tempPosition;
  set tempPosition(LatLng? position) {
    _tempPosition = position;
    notifyListeners();
  }

  Placemark? _tempPositionPlacemark;
  Placemark? get tempPositionPlacemark => _tempPositionPlacemark;
  set tempPositionPlacemark(Placemark? placemark) {
    _tempPositionPlacemark = placemark;
    DebugUtils.printSuccess('set placemark: ${placemark.toString()}');
    notifyListeners();
  }

  void setHomeAsCurrentPosition(WidgetRef ref) async {
    final geolocationVM = ref.read(geolocationProvider);
    final authVM = ref.read(authenticationProvider);
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

  void onSubmittedHome(String value, WidgetRef ref) async {
    final geolocationVM = ref.read(geolocationProvider);
    if (value.length > 3) {
      await geolocationVM.getLocationsFromAddress(value).then((latLng) {
        geolocationVM.getPlacemarkFromCoordinates(latLng).then((placemark) {
          if (placemark != null) {
            tempPositionPlacemark = placemark;
          }
        });
        tempPosition = latLng;
      });
    }
  }

  void onPressedContinue(
    BuildContext context, {
    required WidgetRef ref,
    required String userName,
  }) async {
    final authVM = ref.read(authenticationProvider);
    final firestoreDBVM = ref.read(firestoreDatabaseProvider);
    if (authVM.currentUser != null) {
      if (userName == "") {
        MotionToast.warning(
          title: const Text("Warning"),
          description: const Text(
            "Please provide user display name.",
          ),
          position: MotionToastPosition.top,
          animationType: AnimationType.fromTop,
        ).show(
          context,
        );
        return;
      }
      authVM.updateDisplayName(userName);
      firestoreDBVM.setCurrentUserBasicInfo(
        authVM.currentUser!,
      );
      if (tempPosition != null) {
        final mapVM = ref.read(mapProvider);
        mapVM.setStartCenter(tempPosition!);
      }
      Navigator.of(context).pushReplacementNamed(RouteNames.map);
    } else {
      Navigator.of(context).pushReplacementNamed(RouteNames.authentication);
    }
  }
}
