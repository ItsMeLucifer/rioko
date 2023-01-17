import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/back_button.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/main.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            _buildTopPanel(context),
            Expanded(
              flex: 1,
              child: _buildAvatar(context, ref),
            ),
            Expanded(
              flex: 2,
              child: _buildUserInfo(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPanel(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RiokoBackButton(context),
        IconButton(
          onPressed: () => Navigator.of(context).pushNamed(RouteNames.friends),
          icon: const Icon(Icons.people),
        )
      ],
    );
  }

  Widget _buildAvatar(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(360),
      ),
      child: const FittedBox(
        child: Icon(Icons.person),
      ),
    );
  }

  Widget textWidget(
    BuildContext context, {
    required String fieldName,
    String fieldText = '?',
  }) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '$fieldName: ',
                style: Theme.of(context).textTheme.headlineMedium,
                maxLines: 1,
                softWrap: true,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  fieldText,
                  style: Theme.of(context).textTheme.headlineSmall,
                  maxLines: 1,
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildUserInfo(BuildContext context, WidgetRef ref) {
    final authVM = ref.watch(authenticationProvider);
    final geoVM = ref.watch(geolocationProvider);
    final currentUser = authVM.currentUser!;

    return Column(
      children: [
        const SizedBox(height: 50),
        textWidget(context, fieldName: 'Name', fieldText: currentUser.name),
        textWidget(context, fieldName: 'Email', fieldText: currentUser.email),
        textWidget(context,
            fieldName: 'Home', fieldText: currentUser.homeAddress),
      ],
    );
  }
}
