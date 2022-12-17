import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/debug_utils.dart';
import 'package:rioko/main.dart';
import 'package:rioko/viewmodel/geolocation/geolocation_view_model.dart';

class PlaceDetails extends ConsumerWidget {
  const PlaceDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeDetailsVM = ref.watch(placeDetailsProvider);
    final geolocationVM = ref.watch(geolocationProvider);
    final place =
        ref.watch(mapProvider).travelPlaces[placeDetailsVM.placeIndex];
    return FractionallySizedBox(
      heightFactor: 0.97,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50.0,
              right: 20.0,
              left: 20.0,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    place.title,
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        ?.copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      const TextSpan(
                        text: 'Origin: ',
                      ),
                      TextSpan(
                        text: geolocationVM.getAddressFromPlacemark(
                          placeDetailsVM.originPlacemark,
                          administrativeAreaDisplayOption:
                              DisplayOption.showConditionally,
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      const TextSpan(
                        text: 'Destination: ',
                      ),
                      TextSpan(
                        text: geolocationVM.getAddressFromPlacemark(
                          placeDetailsVM.destinationPlacemark,
                          administrativeAreaDisplayOption:
                              DisplayOption.showConditionally,
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      const TextSpan(
                        text: 'Distance: ',
                      ),
                      TextSpan(
                        text: '${place.kilometers}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const TextSpan(text: ' km'),
                    ],
                  ),
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      const TextSpan(
                        text: 'Description: ',
                      ),
                      TextSpan(
                        text: place.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Expanded(flex: 6, child: SizedBox()),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      const TextSpan(
                        text: 'Likes: ',
                      ),
                      TextSpan(
                        text: '${place.likes.length}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      const TextSpan(
                        text: 'Travelled with ',
                      ),
                      TextSpan(
                        text: '${place.comrades.length}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const TextSpan(text: ' comrades'),
                    ],
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox()),
              ],
            ),
          ),
          Positioned(
            left: 10.0,
            top: 10.0,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.close,
                size: 25,
              ),
            ),
          ),
          Positioned(
            right: 10.0,
            top: 10.0,
            child: IconButton(
              onPressed: () {
                ref.read(addNewPlaceProvider).setPlaceToEdit(
                      place,
                      ref,
                    );
                DebugUtils.printInfo(place.toString());
                ref
                    .read(mapProvider)
                    .displayAddNewPlaceBottomSheet(context, ref, edit: true);
              },
              icon: const Icon(
                Icons.menu,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
