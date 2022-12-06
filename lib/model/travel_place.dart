import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/common/utilities.dart';
part 'travel_place.freezed.dart';

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
@freezed
class TravelPlace with _$TravelPlace {
  const factory TravelPlace({
    required String id,
    @Default(<String>[]) List<String> comrades,
    required String countryIso3Code,
    required DateTime date,
    @Default('') String description,
    required LatLng destinationCoordinates,
    @Default(<String>[]) List<String> imagesURLs,
    required double kilometers,
    @Default(<String>[]) List<String> likes,
    required LatLng originCoordinates,
    @Default('') String title,
  }) = _TravelPlace;

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
