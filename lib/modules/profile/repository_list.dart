import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/models/repository_model.dart';

class RepositoryList extends StatelessWidget {
  final List<Repository> repositories;

  RepositoryList({required this.repositories});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: repositories.length,
      itemBuilder: (context, index) {
        final repo = repositories[index];
        return ListTile(
          title: Text(repo.name),
          subtitle: Text(repo.description ?? 'No description'),
          trailing: Text('${repo.stars} ⭐'),
          onTap: () => Modular.to.pushNamed('/webview', arguments: repo.htmlUrl),
        );
      },
    );
  }
}
