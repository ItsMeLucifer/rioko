import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:rioko/common/debug_utils.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/main.dart';
import 'package:rioko/model/travel_place.dart';

class AddNewPlaceViewModel extends ChangeNotifier {
  LatLng? _destination;
  LatLng? get destination => _destination;
  set destination(LatLng? position) {
    _destination = position;
    notifyListeners();
  }

  Placemark? _destinationPlacemark;
  Placemark? get destinationPlacemark => _destinationPlacemark;
  set destinationPlacemark(Placemark? placemark) {
    _destinationPlacemark = placemark;
    notifyListeners();
  }

  LatLng? _origin;
  LatLng? get origin => _origin;
  set origin(LatLng? position) {
    _origin = position;
    notifyListeners();
  }

  Placemark? _originPlacemark;
  Placemark? get originPlacemark => _originPlacemark;
  set originPlacemark(Placemark? placemark) {
    _originPlacemark = placemark;
    notifyListeners();
  }

  TravelPlace? _travelPlace;
  TravelPlace? get travelPlace => _travelPlace;
  set travelPlace(TravelPlace? travelPlace) {
    _travelPlace = travelPlace;
    notifyListeners();
  }

  String _title = '';
  String get title => _title;
  set title(String title) {
    _title = title;
    notifyListeners();
  }

  String _description = '';
  String get description => _description;
  set description(String description) {
    _description = description;
    notifyListeners();
  }

  void saveNewPlace(
    BuildContext context,
    WidgetRef ref, {
    required String titleText,
    required String originText,
    required String destinationText,
    required double? kilometers,
  }) async {
    final authVM = ref.read(authenticationProvider);
    final mapVM = ref.read(mapProvider);
    final baseVM = ref.read(baseProvider);
    await baseVM.addNewPlaceOnSubmittedOrigin(originText);
    await baseVM.addNewPlaceOnSubmittedDestination(destinationText);
    if (authVM.currentUser?.id == null) {
      Navigator.of(context).pushReplacementNamed(RouteNames.authentication);
      return;
    }
    if (travelPlace == null || origin == null || destination == null) return;
    travelPlace = travelPlace?.copyWith(
      originCoordinates: origin,
      destinationCoordinates: destination,
      title: title,
      description: description,
      kilometers: kilometers,
    );
    baseVM.addNewTravelPlaceToFirebase(context);
    mapVM.addTravelPlace(travelPlace!);
  }
}
