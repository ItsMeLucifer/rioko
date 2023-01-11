import 'package:flutter/material.dart';
import 'package:rioko/model/user.dart';
import 'package:rioko/view/friends/widgets/user_tile.dart';

class UsersList extends StatelessWidget {
  final List<User> users;
  const UsersList(this.users, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return UserTile(user);
      },
    );
  }
}
