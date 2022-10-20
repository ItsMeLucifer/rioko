import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
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
}
