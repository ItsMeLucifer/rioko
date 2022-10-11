import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/main.dart';
import 'package:rioko/model/user.dart';
import 'package:rioko/service/firestore_database_service.dart';

class FirestoreDatabaseViewModel extends ChangeNotifier {
  void setCurrentUserBasicInfo(User user) {
    FirestoreDatabaseService().createNewUser(user);
  }

  Future<DocumentSnapshot> getCurrentUserBasicInfo(String userId) async {
    DocumentSnapshot user =
        await FirestoreDatabaseService().getUserInfo(userId);
    return user;
  }
}
