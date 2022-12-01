import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/components/text_field.dart';

class DataCompletionPage extends ConsumerWidget {
  DataCompletionPage({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geolocationVM = ref.watch(geolocationProvider);
    final firestoreDBVM = ref.watch(firestoreDatabaseProvider);
    final authVM = ref.watch(authenticationProvider);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            labelText: 'Name',
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
              Text(geolocationVM.getAddressFromPlacemark(
                  geolocationVM.tempPositionPlacemark)),
              IconButton(
                onPressed: () async {
                  geolocationVM
                      .getCurrentPosition()
                      .then((currentPosition) async {
                    if (currentPosition == null) return;
                    geolocationVM.tempPosition = currentPosition;
                    if (authVM.currentUser != null) {
                      authVM.currentUser = authVM.currentUser!.copyWith(
                        home: currentPosition,
                        homeAddress: geolocationVM.getAddressFromPlacemark(
                            geolocationVM.tempPositionPlacemark),
                      );
                    }
                    await geolocationVM
                        .getPlacemarkFromCoordinates(currentPosition)
                        .then((placemark) {
                      if (placemark != null) {
                        geolocationVM.tempPositionPlacemark = placemark;
                      }
                    });
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
