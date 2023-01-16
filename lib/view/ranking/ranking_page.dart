import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/back_button.dart';
import 'package:rioko/main.dart';

class RankingPage extends ConsumerWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rankingVM = ref.watch(rankingProvider);
    final friendsVM = ref.watch(friendsProvider);
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: RiokoBackButton(context),
            ),
          ],
        ),
      ),
    );
  }
}
