import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/viewmodel/geolocation/geolocation_view_model.dart';

void main() {
  group('_maskActualPosition', () {
    test('returns not the same position', () {
      const position = Position(
        longitude: 36.54,
        latitude: 20.34,
        timestamp: null,
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
      );
      final maskedPosition =
          GeolocationViewModel().maskActualPosition(position);
      final areThePositionValuesSame =
          position.latitude == maskedPosition.latitude ||
              position.longitude == maskedPosition.longitude;
      expect(areThePositionValuesSame, false);
    });
    test('latitude and longitude offset should be more than 0.03', () {
      const position = Position(
        longitude: 36.54,
        latitude: 20.34,
        timestamp: null,
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
      );
      final maskedPosition =
          GeolocationViewModel().maskActualPosition(position);
      final isOffsetValueOK =
          (position.latitude - maskedPosition.latitude).abs() > 0.03 &&
              (position.longitude - maskedPosition.longitude).abs() > 0.03;
      expect(isOffsetValueOK, true);
    });
  });
  group('getAddressFromPlacemark', () {
    test('should return question mark', () {
      final placemark = Placemark();
      final value = GeolocationViewModel().getAddressFromPlacemark(placemark);
      expect(value, '?');
    });
    test('should return only country name', () {
      final placemark = Placemark(country: 'Poland');
      final value = GeolocationViewModel().getAddressFromPlacemark(placemark);
      expect(value, 'Poland');
    });
    test('should return full address', () {
      final placemark = Placemark(
          locality: 'Żagań', administrativeArea: 'Lubuskie', country: 'Poland');
      final value = GeolocationViewModel().getAddressFromPlacemark(placemark);
      expect(value, 'Żagań, Lubuskie, Poland');
    });
  });
  group('getDistanceInKilometers', () {
    test('should return 0 for null inputs', () {
      final value = GeolocationViewModel().getDistanceInKilometers(null, null);
      expect(value, 0.0);
    });
    test('should return 0 for the same place provided two times', () {
      final position = LatLng(20.34, 36.54);
      final value =
          GeolocationViewModel().getDistanceInKilometers(position, position);
      expect(value, 0.0);
    });
    test('should return valid number of kilometers', () {
      final origin = LatLng(0, 0);
      final destination = LatLng(1, 0);
      final value =
          GeolocationViewModel().getDistanceInKilometers(origin, destination);
      expect(value, 111);
    });
  });
}
