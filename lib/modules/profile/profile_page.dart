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
    final sortNotifier = ValueNotifier<String>('created'); // Gerencia o valor do sort

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
          appBar: AppBar(title: Text(loadedUser.login)),
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
        // Card com as informações do usuário
        UserInfoCard(user: profile.user),
        // Lista de repositórios com a opção de ordenação
        Expanded(
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
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ProfileSuccess profile, ProfileBloc bloc, ValueNotifier<String> sortNotifier) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card com as informações do usuário no lado esquerdo
        Expanded(
          flex: 2,
          child: UserInfoCard(user: profile.user),
        ),
        // Lista de repositórios no lado direito com a opção de ordenação
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
    );
  }
}
