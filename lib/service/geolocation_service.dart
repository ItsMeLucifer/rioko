import 'package:geolocator/geolocator.dart';

class GeolocationService {
  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest);
    return position;
  }
}
