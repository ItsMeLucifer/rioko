import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rioko/common/back_button.dart';
import 'package:rioko/common/debug_utils.dart';
import 'package:rioko/common/dialogs/yes_no_dialog.dart';
import 'package:rioko/common/enums.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/main.dart';
import 'package:rioko/view/friends/widgets/users_list.dart';

class FriendsPage extends ConsumerWidget {
  const FriendsPage({Key? key}) : super(key: key);
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
                        'Friends',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    if (friendsVM.friendsFetchStatus == FetchStatus.fetched)
                      UsersList(
                        friendsVM.friends,
                        onPressedUser: (user) => showDialog(
                          context: context,
                          builder: (context) => YesNoDialog(
                            title:
                                'Are you sure you want to remove ${user.name} from friends list?',
                            onPressedYes: () => friendsVM.removeFriend(
                              user.id,
                              authVM.currentUser!.id,
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
              if (friendsVM.friendsFetchStatus != FetchStatus.fetched)
                _buildCircularProgressIndicator(context),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
          overlayOpacity: 0,
          animatedIcon: AnimatedIcons.menu_close,
          foregroundColor:
              Theme.of(context).floatingActionButtonTheme.foregroundColor,
          backgroundColor:
              Theme.of(context).floatingActionButtonTheme.backgroundColor,
          children: [
            SpeedDialChild(
                labelBackgroundColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
                labelStyle: Theme.of(context)
                    .floatingActionButtonTheme
                    .extendedTextStyle,
                onTap: () {
                  friendsVM.searchController.clear();
                  friendsVM.setSearchedFriends([]);
                  Navigator.of(context).pushNamed(RouteNames.searchFriends);
                },
                label: 'Search friends',
                backgroundColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
                child: Icon(
                  Icons.search,
                  color: Theme.of(context)
                      .floatingActionButtonTheme
                      .foregroundColor,
                )),
            SpeedDialChild(
                labelBackgroundColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
                labelStyle: Theme.of(context)
                    .floatingActionButtonTheme
                    .extendedTextStyle,
                onTap: () {
                  final authVM = ref.read(authenticationProvider);
                  friendsVM.fetchFriendRequests(authVM.currentUser!.id);
                  Navigator.of(context).pushNamed(RouteNames.friendRequests);
                },
                label: 'Friend requests',
                backgroundColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
                child: Icon(
                  Icons.people_alt,
                  color: Theme.of(context)
                      .floatingActionButtonTheme
                      .foregroundColor,
                ))
          ]),
    );
  }

  Widget _buildCircularProgressIndicator(BuildContext context) => const Align(
        alignment: Alignment(0, -0.5),
        child: CircularProgressIndicator(),
      );
}
