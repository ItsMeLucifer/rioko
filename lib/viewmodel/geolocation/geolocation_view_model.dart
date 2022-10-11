import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/common/utilities.dart';
import 'package:rioko/service/geolocation_service.dart';

class GeolocationViewModel extends ChangeNotifier {
  LatLng _position = LatLng(0, 0);
  LatLng get position => _position;
  set position(LatLng position) {
    _position = position;
    notifyListeners();
  }

  Placemark _positionPlacemark = Placemark();
  Placemark get positionPlacemark => _positionPlacemark;
  set positionPlacemark(Placemark placemark) {
    _positionPlacemark = placemark;
    notifyListeners();
  }

  Future<LatLng?> getCurrentPosition() async {
    try {
      Position position = await GeolocationService().getCurrentLocation();
      return _maskActualPosition(position);
    } catch (e) {
      debugPrint("Couldn't get current position: $e");
      return null;
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

  Future<Placemark?> getPlacemarkFromCoordinates(LatLng coordinates) async {
    try {
      Placemark placemark =
          await GeolocationService().getPlacemarkFromCoordinates(coordinates);
      return placemark;
    } catch (e) {
      rethrow;
    }
  }

  String getAddressFromPlacemark(Placemark placemark) {
    final cityName = Utilities.checkIfNullOrEmptyString(placemark.locality)
        ? ''
        : '${placemark.locality}, ';
    final administrativeArea =
        Utilities.checkIfNullOrEmptyString(placemark.administrativeArea)
            ? ''
            : '${placemark.administrativeArea}, ';
    return "$cityName$administrativeArea${placemark.country ?? '?'}";
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
