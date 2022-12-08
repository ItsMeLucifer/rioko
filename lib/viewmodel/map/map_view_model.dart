import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/model/travel_place.dart';

class MapViewModel extends ChangeNotifier {
  List<TravelPlace> _travelPlaces = [];
  List<TravelPlace> get travelPlaces => _travelPlaces;
  set travelPlaces(List<TravelPlace> travelPlaces) {
    _travelPlaces = travelPlaces;
    notifyListeners();
  }

  void addTravelPlace(TravelPlace travelPlace) {
    _travelPlaces.add(travelPlace);
    notifyListeners();
  }

  final MapController mapController = MapController();

  LatLng _startCenter = LatLng(0, 0);
  LatLng get startCenter => _startCenter;

  void setStartCenter(LatLng point) {
    _startCenter = point;
    notifyListeners();
  }

  void mapMoveTo({required LatLng position, double zoom = 10}) {
    mapController.move(position, zoom);
  }
}
