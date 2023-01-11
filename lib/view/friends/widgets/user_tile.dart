import 'package:flutter/material.dart';
import 'package:rioko/model/user.dart';

class UserTile extends StatelessWidget {
  final User user;
  const UserTile(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).listTileTheme.tileColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 60,
        ),
        padding: const EdgeInsets.all(10.0),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 1,
              child: _buildUserAvatar(context),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 3,
              child: _buildUserInfo(context),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).listTileTheme.iconColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) => Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              user.name,
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              user.email,
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      );
  Widget _buildUserAvatar(BuildContext context) => Icon(
        Icons.person,
        color: Theme.of(context).listTileTheme.iconColor,
        size: 40,
      );
}
