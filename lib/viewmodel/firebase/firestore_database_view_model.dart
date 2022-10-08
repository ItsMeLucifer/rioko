import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/model/user.dart';
import 'package:rioko/service/firestore_database_service.dart';

class FirestoreDatabaseViewModel extends ChangeNotifier {
  void setCurrentUserBasicInfo(User user) {
    FirestoreDatabaseService().createNewUser(user);
  }
}
