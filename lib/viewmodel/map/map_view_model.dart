import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/main.dart';
import 'package:rioko/model/trip.dart';
import 'package:collection/collection.dart';
import 'package:rioko/view/map/widgets/trip_details/trip_details.dart';
import 'package:rioko/view/map/widgets/add_new_trip/add_new_trip.dart';

class MapViewModel extends ChangeNotifier {
  List<Trip> _trips = [];
  List<Trip> get trips => _trips;
  set trips(List<Trip> trips) {
    _trips = trips;
    notifyListeners();
  }

  void addTrip(Trip trip) {
    final original = _trips.firstWhereOrNull(
      (p) => p.id == trip.id,
    );
    if (original != null) {
      _trips.remove(original);
    }
    _trips.add(trip);
    notifyListeners();
  }

  final MapController mapController = MapController();

  LatLng _startCenter = LatLng(0, 0);
  LatLng get startCenter => _startCenter;

  void setStartCenter(LatLng point) {
    _startCenter = point;
    notifyListeners();
  }

  void mapMoveTo({required LatLng position, double zoom = 10}) {
    mapController.move(position, zoom);
  }

  Future _prepareAddNewTripModel(WidgetRef ref, bool edit) async {
    final authVM = ref.read(authenticationProvider);
    final addNewTripVM = ref.read(addNewTripProvider);
    final geolocationVM = ref.read(geolocationProvider);
    if (!edit) {
      addNewTripVM.trip = Trip.newTrip;
      if (authVM.currentUser?.home != null) {
        addNewTripVM.trip =
            addNewTripVM.trip.copyWith(origin: authVM.currentUser!.home);
        addNewTripVM.originPlacemark = await geolocationVM
            .getPlacemarkFromCoordinates(authVM.currentUser!.home!);
      }
      addNewTripVM.destinationPlacemark = null;
      return;
    }
    if (addNewTripVM.trip.origin != null) {
      addNewTripVM.originPlacemark = await geolocationVM
          .getPlacemarkFromCoordinates(addNewTripVM.trip.origin!);
    }
    if (addNewTripVM.trip.destination != null) {
      addNewTripVM.destinationPlacemark = await geolocationVM
          .getPlacemarkFromCoordinates(addNewTripVM.trip.destination!);
    }
  }

  void displayAddNewTripBottomSheet(
    BuildContext context,
    WidgetRef ref, {
    bool edit = false,
  }) async {
    _prepareAddNewTripModel(ref, edit);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (_) => AddNewTrip(edit: edit),
      isScrollControlled: true,
    );
  }

  void displayTripDetailsBottomSheet(
    BuildContext context, {
    required WidgetRef ref,
    required Trip trip,
  }) async {
    final tripDetailsVM = ref.read(tripDetailsProvider);
    final mapVM = ref.read(mapProvider);
    final geolocationVM = ref.read(geolocationProvider);
    tripDetailsVM.tripIndex = mapVM.trips.indexOf(trip);
    tripDetailsVM.originPlacemark =
        await geolocationVM.getPlacemarkFromCoordinates(trip.origin!);
    tripDetailsVM.destinationPlacemark =
        await geolocationVM.getPlacemarkFromCoordinates(trip.destination!);
    showModalBottomSheet(
      context: context,
      builder: (_) => const TripDetails(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void removeTripLocally(String tripId) {
    _trips.removeWhere((p) => p.id == tripId);
    notifyListeners();
  }
}
