import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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

  Placemark _currentPositionPlacemark = Placemark();
  Placemark get currentPositionPlacemark => _currentPositionPlacemark;
  set currentPositionPlacemark(Placemark placemark) {
    _currentPositionPlacemark = placemark;
    notifyListeners();
  }

  Future<void> getCurrentPosition() async {
    try {
      Position position = await GeolocationService().getCurrentLocation();
      currentPosition = _maskActualPosition(position);
    } catch (e) {
      debugPrint("Couldn't get current position: $e");
    }
  }

  LatLng _maskActualPosition(Position position) {
    final random = Random();
    double latitudeOffset = 0;
    double longitudeOffset = 0;
    while ((latitudeOffset > -0.03 && latitudeOffset < 0.03) ||
        (longitudeOffset > -0.03 && longitudeOffset < 0.03)) {
      latitudeOffset = random.nextDouble() * (0.06 + 0.06) - 0.06;
      longitudeOffset = random.nextDouble() * (0.06 + 0.06) - 0.06;
    }
    return LatLng(
      position.latitude + latitudeOffset,
      position.longitude + longitudeOffset,
    );
  }

  Future<void> getPlacemaerkFromCoordinates() async {
    try {
      Placemark placemark = await GeolocationService()
          .getPlacemarkFromCoordinates(currentPosition);
      currentPositionPlacemark = placemark;
    } catch (e) {
      debugPrint("Couldn't get adress from coordinates");
    }
  }

  Future<LatLng?> getLocationsFromAddress(String address) async {
    try {
      List<Location> locations =
          await GeolocationService().getLocationsFromAddress(address);
      return LatLng(locations.first.latitude, locations.first.longitude);
    } catch (e) {
      debugPrint("Couldn't get locations from address");
      return null;
    }
  }
}
