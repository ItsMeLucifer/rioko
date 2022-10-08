import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class GeolocationService {
  Future<Position> getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      return position;
    } else {
      throw Future.error('Error with permission: $permission');
    }
    throw Future.error('Unknown error');
  }

  Future<Placemark> getPlacemarkFromCoordinates(LatLng coordinates) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinates.latitude, coordinates.longitude);
    return placemarks.first;
  }
}
