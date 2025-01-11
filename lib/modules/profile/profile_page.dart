import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'profile_bloc.dart';
import 'profile_state.dart';
import 'repository_list.dart';
import 'user_info_card.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<ProfileBloc>();
    final username = Modular.args.data;

    bloc.fetchProfile(username);

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<ProfileState>(
              stream: bloc.stateStream,
              builder: (context, snapshot) {
                if (snapshot.data is ProfileLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.data is ProfileError) {
                  return Center(child: Text((snapshot.data as ProfileError).message));
                } else if (snapshot.data is ProfileSuccess) {
                  final profile = (snapshot.data as ProfileSuccess);
                  return Column(
                    children: [
                      UserInfoCard(user: profile.user),
                      Expanded(
                        child: RepositoryList(repositories: profile.repositories),
                      ),
                    ],
                  );
                }
                return Center(child: Text('Loading profile...'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
