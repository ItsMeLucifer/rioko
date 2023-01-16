import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/main.dart';

class OpenLeaderboardButton extends ConsumerWidget {
  const OpenLeaderboardButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: IconButton(
            onPressed: () {
              ref.read(leaderboardProvider).fetchFriendsStats(ref);
              Navigator.of(context).pushNamed(RouteNames.leaderboard);
            },
            icon: const Icon(Icons.leaderboard),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
