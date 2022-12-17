import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/main.dart';
import 'package:rioko/model/travel_place.dart';
import 'package:collection/collection.dart';
import 'package:rioko/view/Map/widgets/place_details/place_details.dart';
import 'package:rioko/view/map/widgets/add_new_place/add_new_place.dart';

class MapViewModel extends ChangeNotifier {
  List<TravelPlace> _travelPlaces = [];
  List<TravelPlace> get travelPlaces => _travelPlaces;
  set travelPlaces(List<TravelPlace> travelPlaces) {
    _travelPlaces = travelPlaces;
    notifyListeners();
  }

  void addTravelPlace(TravelPlace travelPlace) {
    final original = _travelPlaces.firstWhereOrNull(
      (p) => p.id == travelPlace.id,
    );
    if (original != null) {
      _travelPlaces.remove(original);
    }
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

  Future _prepareAddNewPlaceModel(WidgetRef ref, bool edit) async {
    final authVM = ref.read(authenticationProvider);
    final addNewPlaceVM = ref.read(addNewPlaceProvider);
    final geolocationVM = ref.read(geolocationProvider);
    if (!edit) {
      addNewPlaceVM.place = TravelPlace.newPlace;
      if (authVM.currentUser?.home != null) {
        addNewPlaceVM.place =
            addNewPlaceVM.place.copyWith(origin: authVM.currentUser!.home);
        addNewPlaceVM.originPlacemark = await geolocationVM
            .getPlacemarkFromCoordinates(authVM.currentUser!.home!);
      }
      addNewPlaceVM.destinationPlacemark = null;
      return;
    }
    if (addNewPlaceVM.place.origin != null) {
      addNewPlaceVM.originPlacemark = await geolocationVM
          .getPlacemarkFromCoordinates(addNewPlaceVM.place.origin!);
    }
    if (addNewPlaceVM.place.destination != null) {
      addNewPlaceVM.destinationPlacemark = await geolocationVM
          .getPlacemarkFromCoordinates(addNewPlaceVM.place.destination!);
    }
  }

  void displayAddNewPlaceBottomSheet(
    BuildContext context,
    WidgetRef ref, {
    bool edit = false,
  }) async {
    _prepareAddNewPlaceModel(ref, edit);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (_) => AddNewPlace(edit: edit),
      isScrollControlled: true,
    );
  }

  void displayPlaceDetailsBottomSheet(
    BuildContext context, {
    required WidgetRef ref,
    required TravelPlace place,
  }) async {
    final placeDetailsVM = ref.read(placeDetailsProvider);
    final mapVM = ref.read(mapProvider);
    final geolocationVM = ref.read(geolocationProvider);
    placeDetailsVM.placeIndex = mapVM.travelPlaces.indexOf(place);
    placeDetailsVM.originPlacemark =
        await geolocationVM.getPlacemarkFromCoordinates(place.origin!);
    placeDetailsVM.destinationPlacemark =
        await geolocationVM.getPlacemarkFromCoordinates(place.destination!);
    showModalBottomSheet(
      context: context,
      builder: (_) => const PlaceDetails(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void removePlaceLocally(String placeId) {
    _travelPlaces.removeWhere((p) => p.id == placeId);
  }
}
