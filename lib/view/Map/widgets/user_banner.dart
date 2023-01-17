import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/main.dart';

class UserBanner extends ConsumerWidget {
  const UserBanner({Key? key}) : super(key: key);
  final mediumEdgeInsets = const EdgeInsets.all(10.0);
  final smallEdgeInsets = const EdgeInsets.all(5.0);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authVM = ref.watch(authenticationProvider);
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: mediumEdgeInsets,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: Colors.grey[700]!,
              width: 2,
            ),
          ),
          padding: mediumEdgeInsets.copyWith(top: 0.0, bottom: 0.0, right: 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(authVM.currentUser?.name ?? ''),
              Container(
                width: 40,
                height: 40,
                margin: smallEdgeInsets,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(RouteNames.profile),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
