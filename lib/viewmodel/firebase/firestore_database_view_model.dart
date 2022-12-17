import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rioko/common/debug_utils.dart';
import 'package:rioko/model/travel_place.dart';
import 'package:rioko/model/user.dart';
import 'package:rioko/service/firestore_database_service.dart';

class FirestoreDatabaseViewModel extends ChangeNotifier {
  void setCurrentUserBasicInfo(User user) {
    FirestoreDatabaseService.createNewUser(user);
  }

  Future<DocumentSnapshot> getCurrentUserBasicInfo(String userId) async {
    DocumentSnapshot user = await FirestoreDatabaseService.getUserInfo(userId);
    return user;
  }

  Future<bool> addNewPlace(TravelPlace place, String userId) async {
    try {
      await FirestoreDatabaseService.addNewPlace(place, userId);
      return true;
    } catch (e) {
      debugPrint('>>>>>ADD NEW PLACE: ' + e.toString());
    }
    return false;
  }

  Future<List<TravelPlace>> fetchUserPlaces(String userId) async {
    try {
      return await FirestoreDatabaseService.fetchCurrentUserPlaces(userId);
    } catch (e) {
      debugPrint('>>>>>FETCH USER PLACES: ' + e.toString());
    }
    return [];
  }

  Future<String?> removePlace(String placeId, String userId) async {
    try {
      await FirestoreDatabaseService.removePlace(placeId, userId);
      return '';
    } catch (e) {
      DebugUtils.printError(e.toString());
      return e.toString();
    }
  }
}
