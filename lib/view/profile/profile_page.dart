import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/back_button.dart';
import 'package:rioko/common/route_names.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RiokoBackButton(context),
              IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(RouteNames.friends),
                icon: const Icon(Icons.people),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
