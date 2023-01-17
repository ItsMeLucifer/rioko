import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/back_button.dart';
import 'package:rioko/common/debug_utils.dart';
import 'package:rioko/common/dialogs/yes_no_dialog.dart';
import 'package:rioko/common/enums.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/components/text_field.dart';
import 'package:rioko/view/friends/widgets/users_list.dart';

class FriendSearchPage extends ConsumerWidget {
  const FriendSearchPage({Key? key}) : super(key: key);
  final largeEdgeInsets = const EdgeInsets.all(20);
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
                        'Search Friend',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    RiokoTextField(
                      controller: friendsVM.searchController,
                      labelText: 'Input email or username',
                      onSubmitted: (input) {
                        if (friendsVM.friendRequestsFetchStatus ==
                            FetchStatus.unfetched) {
                          final authVM = ref.read(authenticationProvider);
                          friendsVM.fetchFriendRequests(authVM.currentUser!.id);
                        }
                        friendsVM.searchForUser(
                          context,
                          input: input,
                          ref: ref,
                        );
                      },
                    ),
                    if (friendsVM.searchFriendFetchStatus ==
                        FetchStatus.fetched)
                      UsersList(
                        friendsVM.searchedFriends,
                        onPressedUser: (user) => showDialog(
                          context: context,
                          builder: (context) => YesNoDialog(
                            title: 'Send friend invitation to ${user.name}?',
                            onPressedYes: () => friendsVM.sendFriendRequest(
                              user.id,
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
              if (friendsVM.searchFriendFetchStatus == FetchStatus.fetching)
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
