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
          mainAxisSize: MainAxisSize.min, // Centraliza os elementos verticalmente
          children: [
            // Adicionar a imagem no topo
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.asset(
                'assets/logo.png', // Caminho da imagem
                width: 200, // Largura da imagem
              ),
            ),
            // Campo de busca
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (query) => bloc.searchUser(query),
              ),
            ),
            const SizedBox(height: 20), // Espaço entre os elementos
            // Estado do BLoC
            StreamBuilder<HomeState>(
              stream: bloc.stateStream,
              builder: (context, snapshot) {
                if (snapshot.data is HomeLoading) {
                  // Exibe carregamento
                  return const CircularProgressIndicator();
                } else if (snapshot.data is HomeError) {
                  // Exibe mensagem de erro
                  return Text(
                    (snapshot.data as HomeError).message,
                    style: const TextStyle(color: Colors.red),
                  );
                } else if (snapshot.data is HomeSuccess) {
                  final user = (snapshot.data as HomeSuccess).user;

                  // Navega para a página de perfil ao encontrar o usuário
                  Future.microtask(() => Modular.to.pushNamed(
                        '/profile',
                        arguments: user,
                      ));

                  return const SizedBox(); // Evita múltiplas navegações
                }
                return const SizedBox.shrink(); // Estado inicial sem conteúdo
              },
            ),
          ],
        ),
      ),
    );
  }
}
