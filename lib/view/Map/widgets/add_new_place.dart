import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/components/text_field.dart';

class AddNewPlace extends ConsumerWidget {
  AddNewPlace({Key? key}) : super(key: key);

  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticationVM = ref.watch(authenticationProvider);
    final geolocationVM = ref.watch(geolocationProvider);
    final mapVM = ref.watch(mapProvider);
    return Column(
      children: [
        CustomTextField(
          onSubmitted: (value) async {
            if (value.length > 3) {
              await geolocationVM.getLocationsFromAddress(value).then((latLng) {
                if (latLng != null) {
                  mapVM.mapMoveTo(
                    position: latLng,
                  );
                  mapVM.travelPlace!.copyWith(
                    originCoordinates: authenticationVM.currentUser?.home,
                    destinationCoordinates: latLng,
                  );
                }
              });
            }
          },
          controller: addressController,
        ),
      ],
    );
  }
}
