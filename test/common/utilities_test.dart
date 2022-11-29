import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:test/test.dart';
import 'package:rioko/common/utilities.dart';

void main() {
  group('isNullOrEmptyString', () {
    test('value should be true', () {
      final value = Utilities.isNullOrEmptyString("");
      expect(value, true);
    });
    test('value should be true', () {
      final value = Utilities.isNullOrEmptyString(null);
      expect(value, true);
    });
    test('value should be false', () {
      final value = Utilities.isNullOrEmptyString("Something");
      expect(value, false);
    });
  });
  group('geoPointToLatLng', () {
    test('returned LatLng should have right values', () {
      const latitude = 20.34;
      const longitude = 35.67;
      const geoPoint = GeoPoint(latitude, longitude);
      final latLng = LatLng(latitude, longitude);
      final value = Utilities.geoPointToLatLng(geoPoint);
      expect(value, latLng);
    });
  });
  group('latLngToGeoPoint', () {
    test('returned GeoPoint should have right values', () {
      const latitude = 20.34;
      const longitude = 35.67;
      const geoPoint = GeoPoint(latitude, longitude);
      final latLng = LatLng(latitude, longitude);
      final value = Utilities.latLngToGeoPoint(latLng);
      expect(value, geoPoint);
    });
  });
}
