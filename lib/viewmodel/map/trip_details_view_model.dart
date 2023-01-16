import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';

class TripDetailsViewModel extends ChangeNotifier {
  Placemark _originPlacemark = Placemark();
  Placemark get originPlacemark => _originPlacemark;
  set originPlacemark(Placemark? originPlacemark) {
    _originPlacemark = originPlacemark ?? Placemark();
    notifyListeners();
  }

  Placemark _destinationPlacemark = Placemark();
  Placemark get destinationPlacemark => _destinationPlacemark;
  set destinationPlacemark(Placemark? destinationPlacemark) {
    _destinationPlacemark = destinationPlacemark ?? Placemark();
    notifyListeners();
  }

  int _tripIndex = 0;
  int get tripIndex => _tripIndex;
  set tripIndex(int tripIndex) {
    _tripIndex = tripIndex;
    notifyListeners();
  }
}
