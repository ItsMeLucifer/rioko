import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class User {
  final String id;
  final String name;
  final LatLng? home;
  final String email;
  User({
    required this.id,
    required this.name,
    required this.email,
    this.home,
  });

  static User fromFirebase(auth.User user) => User(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
      );

  User copyWith({
    String? id,
    String? name,
    LatLng? home,
    String? email,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        home: home ?? this.home,
      );
}
