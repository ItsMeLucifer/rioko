import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/map/widgets/add_new_place/add_new_place.dart';
import 'package:rioko/view/map/widgets/map_marker.dart';

class MapDisplay extends ConsumerWidget {
  const MapDisplay({Key? key}) : super(key: key);

  void _displayAddNewPlaceBottomSheet(
      BuildContext context, WidgetRef ref) async {
    final mapVM = ref.read(mapProvider);
    final authVM = ref.read(authenticationProvider);
    final addNewPlaceVM = ref.read(addNewPlaceProvider);
    addNewPlaceVM.travelPlace = mapVM.newPlace;
    if (authVM.currentUser?.home != null) {
      final addNewPlaceVM = ref.read(addNewPlaceProvider);
      final geolocationVM = ref.read(geolocationProvider);
      addNewPlaceVM.origin = authVM.currentUser!.home;
      addNewPlaceVM.originPlacemark = await geolocationVM
          .getPlacemarkFromCoordinates(authVM.currentUser!.home!);
    }
    addNewPlaceVM.destination = null;
    addNewPlaceVM.description = '';
    addNewPlaceVM.title = '';
    addNewPlaceVM.destinationPlacemark = null;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (_) => AddNewPlace(),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapVM = ref.watch(mapProvider);
    final authVM = ref.watch(authenticationProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'addNewPlace',
        elevation: 5,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        onPressed: () => _displayAddNewPlaceBottomSheet(context, ref),
        child: const FaIcon(
          FontAwesomeIcons.plus,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapVM.mapController,
            options: MapOptions(
              center: mapVM.startCenter,
              zoom: 6,
              minZoom: 1,
              maxZoom: 15,
              maxBounds: LatLngBounds(
                LatLng(-65, -180.0),
                LatLng(75.0, 180.0),
              ),
              interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              plugins: [
                MarkerClusterPlugin(),
              ],
              onLongPress: (tapPosition, point) => {
                //Add new travel place
              },
            ),
            children: [
              TileLayerWidget(
                options: TileLayerOptions(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.jocs.rioko',
                  retinaMode: MediaQuery.of(context).devicePixelRatio > 1.0,
                ),
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 80,
                  size: const Size(40, 40),
                  markers: [
                    ...mapVM.travelPlaces
                        .map(
                          (travelPlace) => MapUtils.getMarker(
                            point: travelPlace.destinationCoordinates,
                            onPressed: () {
                              mapVM.mapMoveTo(
                                position: travelPlace.destinationCoordinates,
                                zoom: 7,
                              );
                            },
                          ),
                        )
                        .toList(),
                    if (authVM.currentUser != null &&
                        authVM.currentUser!.home != null)
                      Marker(
                        key: UniqueKey(),
                        point: authVM.currentUser!.home!,
                        builder: (_) => const FaIcon(
                          FontAwesomeIcons.houseUser,
                        ),
                      ),
                  ],
                  polygonOptions: const PolygonOptions(
                    borderColor: Colors.redAccent,
                    borderStrokeWidth: 3,
                  ),
                  builder: (context, markers) {
                    return FloatingActionButton(
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      onPressed: null,
                      child: Text(
                        markers.length.toString(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '© OpenStreetMaps',
              ),
            ),
          )
        ],
      ),
    );
  }
}
