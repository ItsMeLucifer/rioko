import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

class MapUtils {
  static Marker getMarker({
    required LatLng point,
    required Function() onPressed,
    double height = 40.0,
    double width = 40.0,
  }) {
    return Marker(
      key: UniqueKey(),
      height: height,
      width: width,
      point: point,
      builder: (_) => IconButton(
        onPressed: onPressed,
        icon: const FaIcon(FontAwesomeIcons.locationPin),
      ),
    );
  }
}
