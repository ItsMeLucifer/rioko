import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class Utilities {
  static bool isNullOrEmptyString(String? string) =>
      string == null || string == '';
  static LatLng geoPointToLatLng(GeoPoint geoPoint) =>
      LatLng(geoPoint.latitude, geoPoint.longitude);
  static GeoPoint latLngToGeoPoint(LatLng latLng) =>
      GeoPoint(latLng.latitude, latLng.longitude);
  static String deleteAllWhitespacesFromString(String input) =>
      input.replaceAll(' ', '');

  /// ```
  /// return kilometers * 1390;
  /// ```
  /// 1265 steps on average for men.<br>
  /// 1515 steps on average for women.<br>
  /// 1390 is an average of these.
  static double convertKilometersIntoSteps(double kilometers) =>
      kilometers * 1390;
}
