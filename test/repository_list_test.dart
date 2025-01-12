import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petize/modules/profile/repository_list.dart';
import 'package:petize/shared/models/repository_model.dart';

void main() {
  group('RepositoryList Widget', () {
    late List<Repository> repositories;

    setUp(() {
      // Mock de repositórios para o teste
      repositories = [
        Repository(
          name: 'Repo 1',
          description: 'Descrição do repositório 1',
          stars: 123,
          updatedAt: DateTime.now().subtract(Duration(days: 2)),
          html_url: 'https://github.com/user/repo1',
        ),
        Repository(
          name: 'Repo 2',
          description: null,
          stars: 456,
          updatedAt: DateTime.now().subtract(Duration(hours: 5)),
          html_url: 'https://github.com/user/repo2',
        ),
      ];
    });

    testWidgets('deve renderizar a lista de repositórios corretamente', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1000,
              child: RepositoryList(
                repositories: repositories,
                initialSort: 'updated',
              ),
            ),
          ),
        ),
      );

      // Verifica se os nomes dos repositórios aparecem na tela
      expect(find.text('Repo 1'), findsOneWidget);
      expect(find.text('Repo 2'), findsOneWidget);

      // Verifica se a descrição é exibida corretamente
      expect(find.text('Descrição do repositório 1'), findsOneWidget);
      expect(find.text('Sem descrição disponível.'), findsOneWidget);

      // Verifica se as estrelas são exibidas
      expect(find.text('123'), findsOneWidget);
      expect(find.text('456'), findsOneWidget);

      // Verifica se as datas de atualização são exibidas
      expect(find.textContaining('Atualizado há 2 dias'), findsOneWidget);
      expect(find.textContaining('Atualizado há 5 horas'), findsOneWidget);
    });

    testWidgets('deve chamar onSortChanged ao alterar a ordenação', (WidgetTester tester) async {
      var sortChangedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1000,
              child: RepositoryList(
                repositories: repositories,
                initialSort: 'updated',
                onSortChanged: (sort) {
                  sortChangedCalled = true;
                  expect(sort, equals('created'));
                },
              ),
            ),
          ),
        ),
      );

      // Abre o dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Seleciona o item "Data de Criação"
      await tester.tap(find.text('Data de Criação').first);
      await tester.pumpAndSettle();

      // Verifica se a função foi chamada
      expect(sortChangedCalled, isTrue);
    });
  });
}
