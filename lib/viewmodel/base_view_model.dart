import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/common/utilities.dart';
import 'package:rioko/viewmodel/firebase/authentication_view_model.dart';
import 'package:rioko/viewmodel/firebase/firestore_database_view_model.dart';
import 'package:rioko/viewmodel/geolocation/geolocation_view_model.dart';
import 'package:rioko/viewmodel/map/add_new_place_view_model.dart';
import 'package:rioko/viewmodel/map/map_view_model.dart';

class BaseViewModel extends ChangeNotifier {
  final FirestoreDatabaseViewModel firestoreDBVM;
  final MapViewModel mapVM;
  final AddNewPlaceViewModel addNewPlaceVM;
  final GeolocationViewModel geolocationVM;
  final AuthenticationViewModel authVM;
  BaseViewModel({
    required this.firestoreDBVM,
    required this.mapVM,
    required this.addNewPlaceVM,
    required this.geolocationVM,
    required this.authVM,
  });

  Future<void> login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    authVM.login(email: email, password: password).then(
      (authenticated) async {
        if (authenticated) {
          final userSnapshot = await firestoreDBVM
              .getCurrentUserBasicInfo(authVM.currentUser!.id);
          final home =
              Utilities.geoPointToLatLng(userSnapshot.get('home') as GeoPoint);
          mapVM.setStartCenter(home);
          final placemark =
              await geolocationVM.getPlacemarkFromCoordinates(home);
          authVM.currentUser = authVM.currentUser!.copyWith(
            home: home,
            homeAddress: geolocationVM.getAddressFromPlacemark(placemark),
          );
          final places =
              await firestoreDBVM.fetchUserPlaces(authVM.currentUser!.id);
          mapVM.travelPlaces = places;
          Navigator.of(context).pushReplacementNamed(RouteNames.map);
        } else {
          MotionToast.error(
            title: const Text("Error"),
            description: Text(
              authVM.exceptionMessage,
            ),
            position: MotionToastPosition.top,
            animationType: AnimationType.fromTop,
            enableAnimation: false,
          ).show(
            context,
          );
        }
      },
    );
  }

  Future<void> register(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    await authVM.signUp(email: email, password: password).then((authenticated) {
      if (authenticated) {
        Navigator.of(context).pushReplacementNamed(RouteNames.dataCompletion);
      } else {
        MotionToast.error(
          title: const Text("Error"),
          description: Text(
            authVM.exceptionMessage,
          ),
          position: MotionToastPosition.top,
          animationType: AnimationType.fromTop,
        ).show(
          context,
        );
      }
    });
  }

  void addNewTravelPlaceToFirebase(BuildContext context) async {
    final response = await firestoreDBVM.addNewPlace(
        addNewPlaceVM.travelPlace!, authVM.currentUser!.id);
    if (response) Navigator.of(context).pop();
  }

  Future addNewPlaceOnSubmittedOrigin(String value) async {
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

  Future addNewPlaceOnSubmittedDestination(String value) async {
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
