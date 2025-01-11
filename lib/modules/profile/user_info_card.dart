import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/models/user_model.dart';

class UserInfoCard extends StatelessWidget {
  final User user;

  UserInfoCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.login,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (user.bio != null) Text(user.bio!),
            if (user.blog != null)
              InkWell(
                onTap: () => Modular.to.pushNamed('/webview', arguments: user.blog),
                child: Text(
                  user.blog!,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
