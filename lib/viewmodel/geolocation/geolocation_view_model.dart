import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/common/utilities.dart';
import 'package:rioko/service/geolocation_service.dart';

enum DisplayOption {
  show,
  showConditionally,
  hide,
}

class GeolocationViewModel extends ChangeNotifier {
  Future<LatLng?> getCurrentPosition() async {
    try {
      Position position = await GeolocationService().getCurrentLocation();
      return maskActualPosition(position);
    } catch (e) {
      debugPrint("Couldn't get current position: $e");
      return null;
    }
  }

  @visibleForTesting
  LatLng maskActualPosition(Position position) {
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

  /// Locality and Country is displayed both for `DisplayOption.show`
  /// and `DisplayOption.showConditionally`.
  ///
  /// If administrativeAreaDisplayOption is set to
  /// `DisplayOption.showConditionally`, administrativeArea will be
  /// displayed only if locality is empty.
  String getAddressFromPlacemark(
    Placemark? placemark, {
    DisplayOption localityDisplayOption = DisplayOption.show,
    DisplayOption administrativeAreaDisplayOption = DisplayOption.show,
    DisplayOption countryDisplayOption = DisplayOption.show,
  }) {
    if (placemark == null) return '';
    String cityName = '';
    if (localityDisplayOption != DisplayOption.hide) {
      cityName = Utilities.isNullOrEmptyString(placemark.locality)
          ? ''
          : '${placemark.locality}, ';
    }
    String administrativeArea = '';
    if (administrativeAreaDisplayOption != DisplayOption.hide) {
      administrativeArea =
          Utilities.isNullOrEmptyString(placemark.administrativeArea)
              ? ''
              : '${placemark.administrativeArea}, ';
      if (administrativeAreaDisplayOption == DisplayOption.showConditionally &&
          cityName != '') {
        administrativeArea = '';
      }
    }
    String country = '';
    if (countryDisplayOption != DisplayOption.hide) {
      country = placemark.country ?? '?';
    }

    return "$cityName$administrativeArea$country";
  }

  Future<LatLng> getLocationsFromAddress(String address) async {
    try {
      List<Location> locations =
          await GeolocationService().getLocationsFromAddress(address);
      return LatLng(locations.first.latitude, locations.first.longitude);
    } catch (e) {
      rethrow;
    }
  }

  static const Distance _distance = Distance();

  double getDistanceInKilometers(LatLng? origin, LatLng? destination) {
    if (origin == null || destination == null) return 0;
    return _distance.as(LengthUnit.Kilometer, origin, destination);
  }
}
