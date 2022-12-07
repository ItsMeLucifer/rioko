import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/model/travel_place.dart';
import 'package:uuid/uuid.dart';

class MapViewModel extends ChangeNotifier {
  List<TravelPlace> _travelPlaces = [
    // TravelPlace(
    //   id: const Uuid().v1(),
    //   comrades: [],
    //   countryIso3Code: 'JPN',
    //   date: DateTime.now(),
    //   description: "A trip to he Japan!",
    //   destinationCoordinates: LatLng(35.71230088708584, 139.770833252413),
    //   imagesURLs: [],
    //   kilometers: 2500,
    //   likes: [],
    //   originCoordinates: LatLng(54.587911860570976, 18.486033223964817),
    //   title: 'JAPAN 2022',
    // ),
    // TravelPlace(
    //   id: const Uuid().v1(),
    //   comrades: [],
    //   countryIso3Code: 'JPN',
    //   date: DateTime.now(),
    //   description: "A trip to he Japan!",
    //   destinationCoordinates: LatLng(35.712389391118585, 139.79457825155612),
    //   imagesURLs: [],
    //   kilometers: 2500,
    //   likes: [],
    //   originCoordinates: LatLng(13.88364806420681, 100.46391912833707),
    //   title: 'THAILAND 2022',
    // )
  ];
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

  TravelPlace get newPlace => TravelPlace(
        id: const Uuid().v1(),
        countryIso3Code: '',
        date: DateTime.now(),
        destinationCoordinates: LatLng(0, 0),
        kilometers: 0,
        originCoordinates: LatLng(0, 0),
      );
}
