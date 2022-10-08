import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/service/geolocation_service.dart';

class GeolocationViewModel extends ChangeNotifier {
  LatLng _currentPosition = LatLng(0, 0);
  LatLng get currentPosition => _currentPosition;
  set currentPosition(LatLng position) {
    _currentPosition = position;
    notifyListeners();
  }

  Future<void> getCurrentPosition() async {
    Position position = await GeolocationService().getCurrentLocation();
    currentPosition = LatLng(position.latitude, position.longitude);
  }
}
