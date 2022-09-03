import 'package:firebase_database/firebase_database.dart';
import 'package:rioko/model/user.dart';

class FirebaseRealtimeDatabase {
  void updateUser(User user) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('/users/${user.id}');
    await ref.update({
      "name": user.name,
      "home": user.home,
      "friends": {
        "anotherUserId": true,
      }
    });
  }
}
