import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/main.dart';

class RankingViewModel extends ChangeNotifier {
  void fetchFriendsStats(WidgetRef ref) async {
    final friendsVM = ref.read(friendsProvider);
  }
}
