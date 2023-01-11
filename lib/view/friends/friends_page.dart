import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/friends/widgets/users_list.dart';

class FriendsPage extends ConsumerWidget {
  const FriendsPage({Key? key}) : super(key: key);
  final largeEdgeInsets = const EdgeInsets.all(20);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsVM = ref.watch(friendsProvider);
    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SafeArea(
        child: Column(
          children: [
            Text(
              'Friends',
              style: Theme.of(context).textTheme.headline3,
            ),
            UsersList(friendsVM.friends),
          ],
        ),
      ),
    ));
  }
}
