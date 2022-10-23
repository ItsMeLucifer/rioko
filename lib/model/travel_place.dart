import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/common/utilities.dart';

///```dart
///class TravelPlace {
///   final String id;
///   final LatLng originCoordinates;
///   final LatLng destinationCoordinates;
///   final List<String> imagesURLs;
///   final String title;
///   final String description;
///   final DateTime date;
///   final double kilometers;
///   final List<String> comrades;
///   final List<String> likes;
///   final String countryIso3Code;
/// }
///```
class TravelPlace {
  final String id;
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
    required this.id,
    this.comrades = const <String>[],
    required this.countryIso3Code,
    required this.date,
    this.description = '',
    required this.destinationCoordinates,
    this.imagesURLs = const <String>[],
    required this.kilometers,
    this.likes = const <String>[],
    required this.originCoordinates,
    this.title = '',
  });

  TravelPlace copyWith({
    LatLng? originCoordinates,
    LatLng? destinationCoordinates,
    List<String>? imagesURLs,
    String? title,
    String? description,
    DateTime? date,
    double? kilometers,
    List<String>? comrades,
    List<String>? likes,
    String? countryIso3Code,
  }) =>
      TravelPlace(
        comrades: comrades ?? this.comrades,
        countryIso3Code: countryIso3Code ?? this.countryIso3Code,
        date: date ?? this.date,
        description: description ?? this.description,
        destinationCoordinates:
            destinationCoordinates ?? this.destinationCoordinates,
        imagesURLs: imagesURLs ?? this.imagesURLs,
        kilometers: kilometers ?? this.kilometers,
        likes: likes ?? this.likes,
        originCoordinates: originCoordinates ?? this.originCoordinates,
        title: title ?? this.title,
        id: id,
      );

  static TravelPlace fromDocumentSnapshot(DocumentSnapshot snapshot) =>
      TravelPlace(
        id: snapshot.get('id') as String,
        countryIso3Code: snapshot.get('country') as String,
        date: DateTime.fromMicrosecondsSinceEpoch(snapshot.get('date') as int),
        destinationCoordinates:
            Utilities.geoPointToLatLng(snapshot.get('destination') as GeoPoint),
        kilometers: snapshot.get('kilometers') as double,
        originCoordinates:
            Utilities.geoPointToLatLng(snapshot.get('origin') as GeoPoint),
        description: snapshot.get('description') as String,
        title: snapshot.get('title') as String,
        imagesURLs: snapshot.get('images').isNotEmpty
            ? snapshot.get('images') as List<String>
            : [],
        likes: snapshot.get('likes').isNotEmpty
            ? snapshot.get('likes') as List<String>
            : [],
        comrades: snapshot.get('comrades').isNotEmpty
            ? snapshot.get('comrades') as List<String>
            : [],
      );
}
