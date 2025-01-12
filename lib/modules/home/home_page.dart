import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_bloc.dart';
import 'home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<HomeBloc>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.asset(
                'assets/logo.png',
                width: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: StreamBuilder<List<String>>(
                stream: bloc.recentSearchesStream,
                builder: (context, snapshot) {
                  final suggestions = snapshot.data ?? [];
                  return Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      return suggestions.where((suggestion) => suggestion.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                    },
                    onSelected: (String selected) {
                      bloc.searchUser(selected);
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Search',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (query) {
                          onFieldSubmitted();
                          bloc.searchUser(query);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            StreamBuilder<HomeState>(
              stream: bloc.stateStream,
              builder: (context, snapshot) {
                if (snapshot.data is HomeLoading) {
                  return const CircularProgressIndicator();
                } else if (snapshot.data is HomeError) {
                  return Text(
                    (snapshot.data as HomeError).message,
                    style: const TextStyle(color: Colors.red),
                  );
                } else if (snapshot.data is HomeSuccess) {
                  final user = (snapshot.data as HomeSuccess).user;

                  Future.microtask(() => Modular.to.pushNamed(
                        '/profile',
                        arguments: user,
                      ));

                  return const SizedBox();
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
