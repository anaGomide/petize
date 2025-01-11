import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_bloc.dart';
import 'home_state.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<HomeBloc>();

    return Scaffold(
      appBar: AppBar(title: Text('Search d_evs')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (query) => bloc.searchUser(query),
            ),
          ),
          Expanded(
            child: StreamBuilder<HomeState>(
              stream: bloc.stateStream,
              builder: (context, snapshot) {
                if (snapshot.data is HomeLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.data is HomeError) {
                  return Center(child: Text((snapshot.data as HomeError).message));
                } else if (snapshot.data is HomeSuccess) {
                  final user = (snapshot.data as HomeSuccess).user;
                  return Center(child: Text('User found: ${user.login}'));
                }
                return Center(child: Text('Enter a username to search.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
