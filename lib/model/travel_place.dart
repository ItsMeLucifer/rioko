import 'package:latlong2/latlong.dart';

class TravelPlace {
  final LatLng originCoordinates;
  final LatLng destinationCoordinates;
  final List<String> imagesURLs;
  final String title;
  final String description;
  final DateTime date;
  final double kilometers;
  //list of friends who were on this trip too
  final List<String> comrades;
  //list of the users who liked this post
  final List<String> likes;
  final String countryIso3Code;

  TravelPlace({
    required this.comrades,
    required this.countryIso3Code,
    required this.date,
    required this.description,
    required this.destinationCoordinates,
    required this.imagesURLs,
    required this.kilometers,
    required this.likes,
    required this.originCoordinates,
    required this.title,
  });
}
