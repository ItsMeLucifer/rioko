import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/main.dart';
import 'package:rioko/model/trip.dart';
import 'package:rioko/service/firestore_database_service.dart';

class AddNewTripViewModel extends ChangeNotifier {
  Trip _trip = Trip.newTrip;
  Trip get trip => _trip;
  set trip(Trip trip) {
    _trip = trip;
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

  Future onSubmittedOrigin(
    BuildContext context, {
    required String value,
    required WidgetRef ref,
  }) async {
    if (value.length < 4) return;
    final geolocationVM = ref.read(geolocationProvider);
    try {
      await geolocationVM.getLocationsFromAddress(value).then((latLng) {
        geolocationVM.getPlacemarkFromCoordinates(latLng).then((placemark) {
          if (placemark != null) {
            originPlacemark = placemark;
          }
        });
        trip = trip.copyWith(origin: latLng);
      });
    } catch (e) {
      MotionToast.error(
        title: const Text("Error - Origin field"),
        description: Text(
          e.toString(),
        ),
        position: MotionToastPosition.top,
        animationType: AnimationType.fromTop,
      ).show(
        context,
      );
    }
  }

  Future onSubmittedDestination(
    BuildContext context, {
    required String value,
    required WidgetRef ref,
  }) async {
    if (value.length < 4) return;
    final geolocationVM = ref.read(geolocationProvider);
    final mapVM = ref.read(mapProvider);
    try {
      await geolocationVM.getLocationsFromAddress(value).then((latLng) {
        geolocationVM.getPlacemarkFromCoordinates(latLng).then((placemark) {
          if (placemark != null) {
            destinationPlacemark = placemark;
          }
        });
        mapVM.mapMoveTo(
          position: latLng,
        );
        trip = trip.copyWith(destination: latLng);
      });
    } catch (e) {
      MotionToast.error(
        title: const Text("Error - Destination field"),
        description: Text(
          e.toString(),
        ),
        position: MotionToastPosition.top,
        animationType: AnimationType.fromTop,
      ).show(
        context,
      );
    }
  }

  void saveNewTrip(
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
    if (trip.origin == null) {
      await onSubmittedOrigin(context, value: originText, ref: ref);
    }
    if (trip.destination == null) {
      await onSubmittedDestination(context, value: destinationText, ref: ref);
    }

    if (authVM.currentUser?.id == null) {
      Navigator.of(context).pushReplacementNamed(RouteNames.authentication);
      return;
    }
    if (trip.origin == null || trip.destination == null || kilometers == 0) {
      return;
    }
    trip = trip.copyWith(
      title: titleText,
      description: descriptionText,
      kilometers: kilometers!,
    );
    // Update kilometers in current user's profile
    FirestoreDatabaseService.updateCurrentUserKilometers(
      authVM.currentUser!.id,
      authVM.currentUser!.kilometers + kilometers,
    );
    baseVM.addNewTripToFirebase(context);
    mapVM.addTrip(trip);
  }

  void setTripToEdit(Trip trip, WidgetRef ref) async {
    final geolocationVM = ref.read(geolocationProvider);
    this.trip = trip;
    if (trip.origin != null) {
      originPlacemark =
          await geolocationVM.getPlacemarkFromCoordinates(trip.origin!);
    }
    if (trip.destination != null) {
      destinationPlacemark =
          await geolocationVM.getPlacemarkFromCoordinates(trip.destination!);
    }
  }

  Future onPressedRemoveTrip(BuildContext context, WidgetRef ref) async {
    final firestoreVM = ref.read(firestoreDatabaseProvider);
    final authVM = ref.read(authenticationProvider);
    //Remove from the database
    String? response;
    if (authVM.currentUser != null) {
      response = await firestoreVM.removeTrip(
        trip.id,
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
    // Update kilometers in current user's profile
    FirestoreDatabaseService.updateCurrentUserKilometers(
      authVM.currentUser!.id,
      authVM.currentUser!.kilometers - trip.kilometers,
    );
    //Remove locally
    final mapVM = ref.read(mapProvider);
    mapVM.removeTripLocally(trip.id);
    Navigator.of(context).popUntil(ModalRoute.withName(RouteNames.map));
  }
}
