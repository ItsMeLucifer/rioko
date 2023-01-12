import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:rioko/common/debug_utils.dart';
import 'package:rioko/common/enums.dart';
import 'package:rioko/common/utilities.dart';
import 'package:rioko/main.dart';
import 'package:rioko/model/user.dart';
import 'package:rioko/service/firestore_database_service.dart';

class FriendsViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  List<User> _friends = [];
  List<User> get friends => _friends;

  void setFriends(List<User> friends) {
    _friends = friends;
    notifyListeners();
  }

  List<User> _searchedfriends = [];
  List<User> get searchedFriends => _searchedfriends;

  void setSearchedFriends(List<User> searchedFriends) {
    _searchedfriends = searchedFriends;
    notifyListeners();
  }

  List<User> _friendRequests = [];
  List<User> get friendRequests => _friendRequests;

  void setFriendRequests(List<User> friendRequests) {
    _friendRequests = friendRequests;
    notifyListeners();
  }

  FetchStatus _friendsFetchStatus = FetchStatus.unfetched;
  FetchStatus get friendsFetchStatus => _friendsFetchStatus;
  set friendsFetchStatus(FetchStatus friendsFetchStatus) {
    _friendsFetchStatus = friendsFetchStatus;
    notifyListeners();
  }

  FetchStatus _searchFriendFetchStatus = FetchStatus.unfetched;
  FetchStatus get searchFriendFetchStatus => _searchFriendFetchStatus;
  set searchFriendFetchStatus(FetchStatus searchFriendFetchStatus) {
    _searchFriendFetchStatus = searchFriendFetchStatus;
    notifyListeners();
  }

  FetchStatus _friendRequestsFetchStatus = FetchStatus.unfetched;
  FetchStatus get friendRequestsFetchStatus => _friendRequestsFetchStatus;
  set friendRequestsFetchStatus(FetchStatus friendRequestsFetchStatus) {
    _friendRequestsFetchStatus = friendRequestsFetchStatus;
    notifyListeners();
  }

  Future fetchFriends(
    String currentUserId,
  ) async {
    friendsFetchStatus = FetchStatus.fetching;
    try {
      final friends =
          await FirestoreDatabaseService.fetchCurrentUserFriends(currentUserId);
      friendsFetchStatus = FetchStatus.fetched;
      setFriends(friends);
    } catch (e) {
      DebugUtils.printError('Could not fetch friends: $e');
      friendsFetchStatus = FetchStatus.unfetched;
    }
  }

  Future searchForUser(
    BuildContext context, {
    required String input,
    required WidgetRef ref,
  }) async {
    final authVM = ref.read(authenticationProvider);
    searchFriendFetchStatus = FetchStatus.fetching;
    input = Utilities.deleteAllWhitespacesFromString(input);
    if (input.length < 4) {
      MotionToast.warning(
        title: const Text("Search error"),
        description: const Text(
          "You need to provide at least 3 characters.",
        ),
        position: MotionToastPosition.top,
        animationType: AnimationType.fromTop,
      ).show(
        context,
      );
      return;
    }
    try {
      final users = await FirestoreDatabaseService.searchForUsers(input);
      users.removeWhere(
        (u) =>
            friendRequests.any((r) => r.id == u.id) ||
            friends.any((f) => f.id == u.id) ||
            u.id == authVM.currentUser!.id,
      );
      searchFriendFetchStatus = FetchStatus.fetched;
      setSearchedFriends(users);
    } catch (e) {
      DebugUtils.printError('Could not search for user: $e');
      searchFriendFetchStatus = FetchStatus.unfetched;
    }
  }

  Future fetchFriendRequests(
    String currentUserId,
  ) async {
    friendRequestsFetchStatus = FetchStatus.fetching;
    try {
      final users =
          await FirestoreDatabaseService.fetchFriendRequests(currentUserId);
      friendRequestsFetchStatus = FetchStatus.fetched;
      setFriendRequests(users);
    } catch (e) {
      DebugUtils.printError('Could not fetch friend requests: $e');
      friendRequestsFetchStatus = FetchStatus.unfetched;
    }
  }

  Future removeFriend(
    String friendId,
    String currentUserId,
  ) async {
    try {
      await FirestoreDatabaseService.removeFriend(friendId, currentUserId).then(
        (_) => friends.removeWhere(
          (f) => f.id == friendId,
        ),
      );
      notifyListeners();
    } catch (e) {
      DebugUtils.printError('Could not remove a friend: $e');
    }
  }

  Future sendFriendRequest(
    String targetUserId,
    User currentUser,
  ) async {
    try {
      await FirestoreDatabaseService.sendFriendRequest(
        targetUserId,
        currentUser,
      );
    } catch (e) {
      DebugUtils.printError('Could not send a friend request: $e');
    }
  }

  Future acceptFriendRequest(
    User targetUser,
    User currentUser,
  ) async {
    try {
      await FirestoreDatabaseService.acceptFriendRequest(
        targetUser,
        currentUser,
      ).then((_) {
        friendRequests.removeWhere(
          (f) => f.id == targetUser.id,
        );
        friends.add(targetUser);
      });
      notifyListeners();
    } catch (e) {
      DebugUtils.printError('Could not accept a friend request: $e');
    }
  }
}
