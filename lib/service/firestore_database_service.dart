import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rioko/model/user.dart';

class FirestoreDatabaseService {
  void createNewUser(User user) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(user.id).set({
      'id': user.id,
      'email': user.email,
      'home': user.home,
      'name': user.name,
    });
  }
}
