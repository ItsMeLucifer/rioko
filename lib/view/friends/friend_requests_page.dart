import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/back_button.dart';
import 'package:rioko/common/debug_utils.dart';
import 'package:rioko/common/dialogs/yes_no_dialog.dart';
import 'package:rioko/common/enums.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/friends/widgets/users_list.dart';

class FriendRequestsPage extends ConsumerWidget {
  const FriendRequestsPage({Key? key}) : super(key: key);
  final largeEdgeInsets = const EdgeInsets.all(15);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsVM = ref.watch(friendsProvider);
    final authVM = ref.watch(authenticationProvider);
    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: largeEdgeInsets,
                    child: Text(
                      'Friend Requests',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  if (friendsVM.friendRequestsFetchStatus ==
                      FetchStatus.fetched)
                    UsersList(
                      friendsVM.friendRequests,
                      onPressedUser: (user) => showDialog(
                        context: context,
                        builder: (context) => YesNoDialog(
                          title:
                              'Do you accept friend request from ${user.name}?',
                          onPressedYes: () => friendsVM.acceptFriendRequest(
                            user,
                            authVM.currentUser!,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              top: 5.0,
              child: RiokoBackButton(context),
            ),
            if (friendsVM.friendRequestsFetchStatus == FetchStatus.fetching)
              _buildCircularProgressIndicator(context),
          ],
        ),
      ),
    ));
  }

  Widget _buildCircularProgressIndicator(BuildContext context) => const Align(
        alignment: Alignment(0, -0.5),
        child: CircularProgressIndicator(),
      );
}
