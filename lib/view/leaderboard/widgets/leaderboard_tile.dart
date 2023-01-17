import 'package:flutter/material.dart';
import 'package:rioko/common/utilities.dart';
import 'package:rioko/model/user.dart';

class LeaderboardTile extends StatelessWidget {
  final User user;
  const LeaderboardTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const borderSide = BorderSide(color: Colors.black, width: 2);
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: borderSide,
          bottom: borderSide,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 5.0),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.grey[400],
          ),
          child: const Icon(
            Icons.person,
            size: 50,
          ),
        ),
        title: Text(
          user.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        subtitle: Text(
          '${user.kilometers.toInt()} km  |  ${Utilities.convertKilometersIntoSteps(user.kilometers).toInt()} 👣',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
