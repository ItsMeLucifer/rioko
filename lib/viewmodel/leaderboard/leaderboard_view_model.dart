import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/debug_utils.dart';
import 'package:rioko/common/enums.dart';
import 'package:rioko/main.dart';
import 'package:rioko/service/firestore_database_service.dart';

class LeaderboardViewModel extends ChangeNotifier {
  FetchStatus _friendsStatsFetchStatus = FetchStatus.unfetched;
  FetchStatus get friendsStatsFetchStatus => _friendsStatsFetchStatus;
  set friendsStatsFetchStatus(FetchStatus friendsStatsFetchStatus) {
    _friendsStatsFetchStatus = friendsStatsFetchStatus;
    notifyListeners();
  }

  void fetchFriendsStats(WidgetRef ref) async {
    _friendsStatsFetchStatus = FetchStatus.fetching;
    final friendsVM = ref.read(friendsProvider);
    final friendIds = friendsVM.friends.map((f) => f.id).toList();
    try {
      final friends =
          await FirestoreDatabaseService.fetchFriendsStats(friendIds);
      friendsVM.setFriends(friends);
      _friendsStatsFetchStatus = FetchStatus.fetched;
    } catch (e) {
      DebugUtils.printError("Could not fetch friends' statistics: $e");
      _friendsStatsFetchStatus = FetchStatus.unfetched;
    }
  }
}
