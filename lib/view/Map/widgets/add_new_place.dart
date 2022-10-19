import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/components/text_field.dart';

class AddNewPlace extends ConsumerWidget {
  AddNewPlace({Key? key}) : super(key: key);

  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authVM = ref.watch(authenticationProvider);
    final geolocationVM = ref.watch(geolocationProvider);
    final mapVM = ref.watch(mapProvider);
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'From: ',
            style: const TextStyle(color: Colors.black),
            children: [
              authVM.currentUser?.home == null
                  ? const TextSpan(text: '-')
                  : TextSpan(text: authVM.currentUser?.homeAddress),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: CustomTextField(
                enabled: geolocationVM.position == null,
                onSubmitted: (value) async {
                  if (value.length > 3) {
                    await geolocationVM
                        .getLocationsFromAddress(value)
                        .then((latLng) {
                      if (latLng != null) {
                        geolocationVM
                            .getPlacemarkFromCoordinates(latLng)
                            .then((placemark) {
                          if (placemark != null) {
                            geolocationVM.positionPlacemark = placemark;
                          }
                        });
                        mapVM.mapMoveTo(
                          position: latLng,
                        );
                        mapVM.travelPlace!.copyWith(
                          originCoordinates: authVM.currentUser?.home,
                          destinationCoordinates: latLng,
                        );
                        geolocationVM.position = latLng;
                      }
                    });
                  }
                },
                hintText: geolocationVM.positionPlacemark.country == null
                    ? 'Where did you travel?'
                    : geolocationVM.getAddressFromPlacemark(
                        geolocationVM.positionPlacemark),
                controller: addressController,
              ),
            ),
            Expanded(
              child: IconButton(
                enableFeedback: geolocationVM.position != null,
                onPressed: () {
                  geolocationVM.position = null;
                  geolocationVM.positionPlacemark = Placemark();
                },
                icon: const Icon(Icons.edit),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
