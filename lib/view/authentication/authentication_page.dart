import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/common/utilities.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/components/text_field.dart';

class AuthenticationPage extends ConsumerWidget {
  AuthenticationPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapVM = ref.watch(mapProvider);
    final authVM = ref.watch(authenticationProvider);
    final geolocationVM = ref.watch(geolocationProvider);
    final firestoreDBVM = ref.watch(firestoreDatabaseProvider);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            authVM.exceptionMessage,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          CustomTextField(
            controller: emailController,
            onChanged: (value) {
              authVM.exceptionMessage = '';
            },
          ),
          CustomTextField(
            controller: passwordController,
            onChanged: (value) {
              authVM.exceptionMessage = '';
            },
            obscureText: true,
          ),
          IconButton(
            onPressed: () {
              authVM
                  .login(
                      email: emailController.text,
                      password: passwordController.text)
                  .then(
                (authenticated) async {
                  if (authenticated) {
                    Navigator.of(context).pushReplacementNamed(RouteNames.map);
                    final userSnapshot = await firestoreDBVM
                        .getCurrentUserBasicInfo(authVM.currentUser!.id);
                    final home = Utilities.geoPointToLatLng(
                        userSnapshot.get('home') as GeoPoint);
                    final placemark =
                        await geolocationVM.getPlacemarkFromCoordinates(home);
                    authVM.currentUser = authVM.currentUser!.copyWith(
                      home: home,
                      homeAddress: placemark != null
                          ? geolocationVM.getAddressFromPlacemark(placemark)
                          : null,
                    );
                  }
                },
              );
            },
            icon: const Icon(Icons.login),
          ),
          IconButton(
            onPressed: () {
              authVM
                  .signUp(
                      email: emailController.text,
                      password: passwordController.text)
                  .then((authenticated) {
                if (authenticated) {
                  Navigator.of(context)
                      .pushReplacementNamed(RouteNames.dataCompletion);
                }
              });
            },
            icon: const Icon(Icons.create),
          ),
        ],
      ),
    );
  }
}
