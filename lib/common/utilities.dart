import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class Utilities {
  static bool isNullOrEmptyString(String? string) =>
      string == null || string == '';
  static LatLng geoPointToLatLng(GeoPoint geoPoint) =>
      LatLng(geoPoint.latitude, geoPoint.longitude);
  static GeoPoint latLngToGeoPoint(LatLng latLng) =>
      GeoPoint(latLng.latitude, latLng.longitude);
}
