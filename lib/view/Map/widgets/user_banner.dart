import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/main.dart';

class UserBanner extends ConsumerWidget {
  const UserBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authVM = ref.watch(authenticationProvider);
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: Colors.grey[700]!,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.people_alt,
                  color: Colors.white,
                ),
              ),
              Text(authVM.currentUser?.name ?? '')
            ],
          ),
        ),
      ),
    );
  }
}
