import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/services/github_service.dart';
import 'home_state.dart';

class HomeBloc {
  final _stateController = StreamController<HomeState>.broadcast();
  final GitHubService githubService = GitHubService();

  Stream<HomeState> get stateStream => _stateController.stream;

  Future<void> searchUser(String username) async {
    _stateController.add(HomeLoading());
    try {
      // Busca o usuário na API
      final user = await githubService.fetchUser(username);

      // Salva o login do usuário no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      print('User login saved: ${prefs.getString('login')}');

      prefs.setString('user_login', user.login);

      // Atualiza o estado para sucesso
      _stateController.add(HomeSuccess(user));
    } catch (e) {
      // Atualiza o estado para erro
      _stateController.add(HomeError('User not found.'));
    }
  }

  void dispose() {
    _stateController.close();
  }
}
