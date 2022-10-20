import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:rioko/common/utilities.dart';
import 'package:rioko/model/travel_place.dart';
import 'package:rioko/model/user.dart';

class FirestoreDatabaseService {
  void createNewUser(User user) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(user.id).set({
      'id': user.id,
      'email': user.email,
      'home': GeoPoint(user.home?.latitude ?? 0, user.home?.longitude ?? 0),
      'name': user.name,
    });
  }

  Future<DocumentSnapshot> getUserInfo(String userId) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot user = await users.doc(userId).get();
    return user;
  }

  Future<void> addNewPlace(TravelPlace place, String userId) async {
    debugPrint('got: $place, $userId');
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(userId).collection('places').doc(place.id).set({
      'id': place.id,
      'origin': Utilities.latLngToGeoPoint(place.originCoordinates),
      'destination': Utilities.latLngToGeoPoint(place.destinationCoordinates),
      'images': place.imagesURLs,
      'title': place.title,
      'description': place.description,
      'date': place.date.microsecondsSinceEpoch,
      'kilometers': place.kilometers,
      'comrades': place.comrades,
      'likes': place.likes,
      'country': place.countryIso3Code,
    });
  }
}
