import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    LatLng? home,
    @Default('') String homeAddress,
    @Default(0.0) double kilometers,
  }) = _User;

  static User fromFirebase(auth.User user) => User(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
      );
  static User fromDocumentSnapshot(DocumentSnapshot snapshot) => User(
        id: snapshot.get('id') as String,
        name: snapshot.get('name') as String,
        email: snapshot.get('email') as String,
        kilometers: snapshot.get('kilometers') as double,
      );
  static Map<String, dynamic> toMap(User user) => {
        "id": user.id,
        "name": user.name,
        "email": user.email,
      };
}
