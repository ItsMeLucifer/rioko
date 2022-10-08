import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/components/text_field.dart';
import 'package:geolocator/geolocator.dart';

class DataCompletionPage extends ConsumerWidget {
  DataCompletionPage({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geolocationVM = ref.watch(geolocationProvider);
    final firestoreDBVM = ref.watch(firestoreDatabaseProvider);
    final authVM = ref.watch(authenticationProvider);
    final placemark = geolocationVM.currentPositionPlacemark;
    final cityName = placemark.locality == null || placemark.locality == ''
        ? ''
        : '${placemark.locality}, ';
    final administrativeArea = placemark.administrativeArea == null ||
            placemark.administrativeArea == ''
        ? ''
        : '${placemark.administrativeArea}, ';
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            hintText: 'Name',
            controller: nameController,
            onChanged: (value) {
              if (authVM.currentUser != null) {
                authVM.currentUser = authVM.currentUser!.copyWith(
                  name: nameController.text,
                );
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$cityName$administrativeArea${placemark.country ?? '?'}"),
              IconButton(
                onPressed: () async {
                  geolocationVM.getCurrentPosition().then((_) {
                    if (authVM.currentUser != null) {
                      authVM.currentUser = authVM.currentUser!.copyWith(
                        home: geolocationVM.currentPosition,
                      );
                    }
                    geolocationVM.getPlacemaerkFromCoordinates();
                  });
                },
                icon: const Icon(Icons.location_city),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              if (authVM.currentUser != null) {
                firestoreDBVM.setCurrentUserBasicInfo(
                  authVM.currentUser!,
                );
                Navigator.of(context).pushReplacementNamed(RouteNames.map);
              } else {
                Navigator.of(context)
                    .pushReplacementNamed(RouteNames.authentication);
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
