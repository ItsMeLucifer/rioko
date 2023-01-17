import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/color_palette.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/components/app_logo.dart';
import 'package:rioko/view/components/button.dart';
import 'package:rioko/view/components/text_field.dart';

class DataCompletionPage extends ConsumerWidget {
  DataCompletionPage({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController homeController = TextEditingController();
  final FocusNode homeFocus = FocusNode();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataCompletionVM = ref.watch(dataCompletionProvider);
    final geolocationVM = ref.watch(geolocationProvider);
    final firestoreDBVM = ref.watch(firestoreDatabaseProvider);
    final authVM = ref.watch(authenticationProvider);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            flex: 2,
            child: SizedBox(),
          ),
          const AppLogo(),
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Column(
            children: [
              Text(
                'Please complete your data',
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 20.0),
              RiokoTextField(
                  labelText: 'Name',
                  controller: nameController,
                  fillColor: ColorPalette.babyBlue,
                  onChanged: (value) {
                    if (authVM.currentUser != null) {
                      authVM.currentUser = authVM.currentUser!.copyWith(
                        name: nameController.text,
                      );
                    }
                  },
                  prefix: 'Name'),
              RiokoTextField(
                focusNode: homeFocus,
                controller: homeController,
                labelText: dataCompletionVM.tempPositionPlacemark == null
                    ? 'Home'
                    : geolocationVM.getAddressFromPlacemark(
                        dataCompletionVM.tempPositionPlacemark!),
                onSubmitted: (String value) {
                  homeController.clear();
                  dataCompletionVM.onSubmittedHome(value, ref);
                },
                sufixIconData: Icons.location_searching,
                onPressedSuffixIcon: () {
                  homeController.clear();
                  dataCompletionVM.setHomeAsCurrentPosition(ref);
                  homeFocus.unfocus();
                },
                prefix: 'Home',
              ),
              RiokoButton(
                text: 'Continue',
                onPressed: () {
                  dataCompletionVM.onPressedContinue(
                    context,
                    ref: ref,
                    userName: nameController.text,
                  );
                },
                icon: Icons.login,
              ),
            ],
          ),
          const Expanded(
            flex: 3,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
