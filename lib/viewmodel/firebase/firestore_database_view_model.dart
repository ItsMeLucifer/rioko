import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rioko/common/debug_utils.dart';
import 'package:rioko/model/trip.dart';
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

  Future<bool> addNewTrip(Trip trip, String userId) async {
    try {
      await FirestoreDatabaseService.addNewTrip(trip, userId);
      return true;
    } catch (e) {
      debugPrint('>>>>>ADD NEW TRIP: ' + e.toString());
    }
    return false;
  }

  Future<List<Trip>> fetchUserTrips(String userId) async {
    try {
      return await FirestoreDatabaseService.fetchCurrentUserTrips(userId);
    } catch (e) {
      debugPrint('>>>>>FETCH USER TRIPS: ' + e.toString());
    }
    return [];
  }

  Future<String?> removeTrip(String tripId, String userId) async {
    try {
      await FirestoreDatabaseService.removeTrip(tripId, userId);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
