import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:rioko/common/debug_utils.dart';
import 'package:rioko/common/utilities.dart';
import 'package:rioko/model/travel_place.dart';
import 'package:rioko/model/user.dart';

class FirestoreDatabaseService {
  static void createNewUser(User user) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(user.id).set({
      'id': user.id,
      'email': user.email,
      'home': GeoPoint(user.home?.latitude ?? 0, user.home?.longitude ?? 0),
      'name': user.name,
    });
  }

  static Future<DocumentSnapshot> getUserInfo(String userId) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot user = await users.doc(userId).get();
    return user;
  }

  static Future<void> addNewPlace(TravelPlace place, String userId) async {
    debugPrint('got: $place, $userId');
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(userId).collection('places').doc(place.id).set({
      'id': place.id,
      'origin': Utilities.latLngToGeoPoint(place.origin!),
      'destination': Utilities.latLngToGeoPoint(place.destination!),
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

  static Future<void> removePlace(String placeId, String userId) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      await users.doc(userId).collection('places').doc(placeId).delete();
    } catch (e) {
      DebugUtils.printError(e.toString());
      rethrow;
    }
  }

  static Future<List<TravelPlace>> fetchCurrentUserPlaces(String userId) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    List<QueryDocumentSnapshot> placeSnapshots = await users
        .doc(userId)
        .collection('places')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        return querySnapshot.docs;
      }
      return [];
    });
    return placeSnapshots
        .map((snapshot) => TravelPlace.fromDocumentSnapshot(snapshot))
        .toList();
  }
}
