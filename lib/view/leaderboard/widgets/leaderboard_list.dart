import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/model/user.dart';
import 'package:rioko/view/leaderboard/widgets/leaderboard_tile.dart';

class LeaderboardList extends ConsumerWidget {
  final List<User> users;
  const LeaderboardList({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    users.sort(((a, b) => b.kilometers.compareTo(a.kilometers)));
    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        return LeaderboardTile(user: users[index]);
      },
    );
  }
}
