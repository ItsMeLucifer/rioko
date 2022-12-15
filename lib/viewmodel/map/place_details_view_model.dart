import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:rioko/main.dart';
import 'package:rioko/model/travel_place.dart';

class PlaceDetailsViewModel extends ChangeNotifier {
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

  int _placeIndex = 0;
  int get placeIndex => _placeIndex;
  set placeIndex(int placeIndex) {
    _placeIndex = placeIndex;
    notifyListeners();
  }
}
