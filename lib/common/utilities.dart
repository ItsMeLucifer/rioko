import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class Utilities {
  static bool checkIfNullOrEmptyString(String? string) =>
      string == null || string == '';
  static LatLng geoPointToLatLng(GeoPoint geoPoint) =>
      LatLng(geoPoint.latitude, geoPoint.longitude);
}
