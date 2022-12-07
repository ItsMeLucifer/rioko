import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
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

  TravelPlace? _place;
  TravelPlace? get place => _place;
  set place(TravelPlace? place) {
    _place = place;
    notifyListeners();
  }
}
