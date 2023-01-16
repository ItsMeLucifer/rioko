import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/back_button.dart';
import 'package:rioko/common/enums.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/leaderboard/widgets/leaderboard_list.dart';

class LeaderboardPage extends ConsumerWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardVM = ref.watch(leaderboardProvider);
    final friendsVM = ref.watch(friendsProvider);
    final authVM = ref.watch(authenticationProvider);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'LEADERBOARD',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(fontSize: 50),
                    ),
                  ),
                  if (leaderboardVM.friendsStatsFetchStatus !=
                      FetchStatus.fetching)
                    LeaderboardList(
                        users: [...friendsVM.friends, authVM.currentUser!]),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: RiokoBackButton(context),
              ),
              if (leaderboardVM.friendsStatsFetchStatus == FetchStatus.fetching)
                _buildCircularProgressIndicator(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularProgressIndicator(BuildContext context) => const Align(
        alignment: Alignment(0, -0.5),
        child: CircularProgressIndicator(),
      );
}
