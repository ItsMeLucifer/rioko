import 'package:latlong2/latlong.dart';

class User {
  final String id;
  final String name;
  final LatLng home;
  final List<String> friends;
  User({
    required this.id,
    required this.name,
    required this.home,
    required this.friends,
  });
}
