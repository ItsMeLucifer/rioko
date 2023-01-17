import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:rioko/common/debug_utils.dart';
import 'package:rioko/common/utilities.dart';
import 'package:rioko/model/travel_place.dart';
import 'package:rioko/model/user.dart';

class FirestoreDatabaseService {
  static CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  static void createNewUser(User user) {
    users.doc(user.id).set({
      'id': user.id,
      'email': user.email,
      'home': GeoPoint(user.home?.latitude ?? 0, user.home?.longitude ?? 0),
      'name': user.name,
    });
  }

  static Future<DocumentSnapshot> getUserInfo(String userId) async {
    DocumentSnapshot user = await users.doc(userId).get();
    return user;
  }

  static Future<void> addNewPlace(TravelPlace place, String userId) async {
    debugPrint('got: $place, $userId');
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

  static Future<void> removePlace(String placeId, String currentUserId) async {
    try {
      await users.doc(currentUserId).collection('places').doc(placeId).delete();
    } catch (e) {
      DebugUtils.printError(e.toString());
      rethrow;
    }
  }

  static Future<List<TravelPlace>> fetchCurrentUserPlaces(
      String currentUserId) async {
    List<QueryDocumentSnapshot> placeSnapshots = await users
        .doc(currentUserId)
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

  static Future<List<User>> fetchCurrentUserFriends(
      String currentUserId) async {
    List<QueryDocumentSnapshot> friendSnapshots = await users
        .doc(currentUserId)
        .collection('friends')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        return querySnapshot.docs;
      }
      return [];
    });
    return friendSnapshots
        .map((snapshot) => User.fromDocumentSnapshot(snapshot))
        .toList();
  }

  static Future<List<User>> searchForUsers(String input) async {
    final isSearchedByEmail = input.contains('@');
    final userSnapshots = await users
        .where(isSearchedByEmail ? 'email' : 'name', isEqualTo: input)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.size > 0) {
        return querySnapshot.docs;
      }
      return [];
    });
    return userSnapshots
        .map((snapshot) => User.fromDocumentSnapshot(snapshot))
        .toList();
  }

  static Future<List<User>> fetchFriendRequests(String currentUserId) async {
    List<QueryDocumentSnapshot> friendSnapshots = await users
        .doc(currentUserId)
        .collection('friend-requests')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        return querySnapshot.docs;
      }
      return [];
    });
    return friendSnapshots
        .map((snapshot) => User.fromDocumentSnapshot(snapshot))
        .toList();
  }

  static Future<void> removeFriend(
      String friendId, String currentUserId) async {
    // Remove current user from friend's friends list
    await users.doc(friendId).collection('friends').doc(currentUserId).delete();
    // Remove friend from current user's friends list
    await users.doc(currentUserId).collection('friends').doc(friendId).delete();
  }

  static Future sendFriendRequest(String targetUserId, User currentUser) async {
    // Add current user to the target user's friend requests list (TO DO outgoing flag = false)
    await users
        .doc(targetUserId)
        .collection('friend-requests')
        .doc(currentUser.id)
        .set(User.toMap(currentUser));
    // Add targetUser'id to current user's friend requests list with outgoing flag
    // TO DO
  }

  static Future acceptFriendRequest(User targetUser, User currentUser) async {
    // Add current user to target user's friends list
    await users
        .doc(targetUser.id)
        .collection('friends')
        .doc(currentUser.id)
        .set(User.toMap(currentUser));
    // Add target user to current user's friends list
    await users
        .doc(currentUser.id)
        .collection('friends')
        .doc(targetUser.id)
        .set(User.toMap(targetUser));
  }
}
