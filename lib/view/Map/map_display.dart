import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/map/widgets/add_new_place.dart';

class MapDisplay extends ConsumerWidget {
  const MapDisplay({Key? key}) : super(key: key);

  void _displayAddNewPlaceBottomSheet(BuildContext context) {
    showModalBottomSheet(context: context, builder: (_) => const AddNewPlace());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapService = ref.watch(mapServiceProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 5,
        onPressed: () => _displayAddNewPlaceBottomSheet(context),
        label: const SizedBox(
          width: 50,
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(35.68518815714286, 139.75280093812933),
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
              PolylineLayerWidget(
                options: PolylineLayerOptions(
                  polylineCulling: false,
                  polylines: mapService.travelPlaces
                      .map(
                        (travelPlace) => Polyline(
                          points: [
                            travelPlace.originCoordinates,
                            travelPlace.destinationCoordinates,
                          ],
                          color: Colors.black,
                        ),
                      )
                      .toList(),
                ),
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 80,
                  size: const Size(40, 40),
                  markers: mapService.travelPlaces
                      .map(
                        (travelPlace) => Marker(
                          height: 40,
                          width: 40,
                          point: travelPlace.destinationCoordinates,
                          builder: (_) => IconButton(
                            icon: const FittedBox(
                              child: FaIcon(
                                FontAwesomeIcons.locationDot,
                              ),
                            ),
                            onPressed: () {
                              print('clicked');
                            },
                          ),
                        ),
                      )
                      .toList(),
                  polygonOptions: const PolygonOptions(
                    borderColor: Colors.redAccent,
                    borderStrokeWidth: 3,
                  ),
                  builder: (context, markers) {
                    return FloatingActionButton(
                      backgroundColor: Colors.black,
                      onPressed: null,
                      child: Text(
                        markers.length.toString(),
                      ),
                    );
                  },
                ),
              )
            ],
            mapController: mapService.mapController,
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
