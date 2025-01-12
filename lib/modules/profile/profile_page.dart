import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/models/user_model.dart';
import '../../shared/utils/responsive.dart';
import 'profile_bloc.dart';
import 'profile_state.dart';
import 'repository_list.dart';
import 'user_info_card.dart';

class ProfilePage extends StatelessWidget {
  final User? user;

  const ProfilePage({super.key, this.user});

  Future<User> _loadUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return User(
      login: prefs.getString('login') ?? '',
      name: prefs.getString('name') ?? '',
      avatarUrl: prefs.getString('avatar_url') ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<ProfileBloc>();
    final sortNotifier = ValueNotifier<String>('created');

    return FutureBuilder<User>(
      future: user != null ? Future.value(user) : _loadUserFromPreferences(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final loadedUser = snapshot.data!;
        bloc.fetchProfile(loadedUser.login);

        return Scaffold(
          appBar: AppBar(
            title: Row(
              spacing: 150,
              children: [
                // Logo na AppBar
                Image.asset(
                  'assets/logo.png',
                  width: 200,
                ),

                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 500,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                          hintText: loadedUser.name ?? loadedUser.login,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onSubmitted: (query) {
                          bloc.fetchProfile(query);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.white,
          ),
          body: StreamBuilder<ProfileState>(
            stream: bloc.stateStream,
            builder: (context, snapshot) {
              if (snapshot.data is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.data is ProfileError) {
                return Center(
                  child: Text((snapshot.data as ProfileError).message),
                );
              } else if (snapshot.data is ProfileSuccess) {
                final profile = (snapshot.data as ProfileSuccess);

                return ValueListenableBuilder<String>(
                  valueListenable: sortNotifier,
                  builder: (context, sort, _) {
                    // Verifica se é mobile ou tablet
                    if (Responsive.isMobile(context) || Responsive.isTablet(context)) {
                      return _buildMobileLayout(context, profile, bloc, sortNotifier);
                    } else {
                      return _buildDesktopLayout(context, profile, bloc, sortNotifier);
                    }
                  },
                );
              }
              return const Center(child: Text('Loading profile...'));
            },
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, ProfileSuccess profile, ProfileBloc bloc, ValueNotifier<String> sortNotifier) {
    return Column(
      children: [
        UserInfoCard(user: profile.user),
        Expanded(
          child: RepositoryList(
            repositories: profile.repositories,
            initialSort: sortNotifier.value,
            onSortChanged: (sort) {
              sortNotifier.value = sort;
              bloc.fetchProfile(profile.user.login, sort: sort);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ProfileSuccess profile, ProfileBloc bloc, ValueNotifier<String> sortNotifier) {
    return Padding(
      padding: const EdgeInsets.all(32.0), // Margem para a tela
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ajusta ao conteúdo
              crossAxisAlignment: CrossAxisAlignment.stretch, // Faz o botão ter a mesma largura que o UserInfoCard
              children: [
                UserInfoCard(user: profile.user),
                const SizedBox(height: 16), // Espaçamento entre o Card e o botão
                ElevatedButton(
                  onPressed: () {
                    // Adicione a lógica do botão "Contato"
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0), // Borda arredondada de 6px
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12), // Altura do botão
                  ),
                  child: const Text(
                    'Contato',
                    style: TextStyle(color: Colors.white), // Texto do botão
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 32), // Espaçamento entre o Card e a lista de repositórios
          Expanded(
            flex: 5,
            child: RepositoryList(
              repositories: profile.repositories,
              initialSort: sortNotifier.value, // Passa o valor do sort atual
              onSortChanged: (sort) {
                sortNotifier.value = sort; // Atualiza o valor do sort
                bloc.fetchProfile(profile.user.login, sort: sort); // Atualiza com o novo parâmetro
              },
            ),
          ),
        ],
      ),
    );
  }
}
