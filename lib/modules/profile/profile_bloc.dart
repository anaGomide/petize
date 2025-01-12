import 'dart:async';

import 'package:petize/modules/profile/profile_state.dart';

import '../../shared/models/repository_model.dart';
import '../../shared/models/user_model.dart';
import '../../shared/services/github_service.dart';
import '../../shared/services/user_preferences_service.dart';

class ProfileBloc {
  final _stateController = StreamController<ProfileState>.broadcast();
  final GitHubService githubService = GitHubService();
  final UserPreferencesService userPreferences = UserPreferencesService();

  Stream<ProfileState> get stateStream => _stateController.stream;

  Future<void> fetchProfile(String username, {String? sort}) async {
    _stateController.add(ProfileLoading());
    try {
      User? user;
      List<Repository>? repositories;

      if (username.isEmpty) {
        user = await userPreferences.loadUser();

        if (user != null) {
          repositories = await githubService.fetchRepositories(user.login, sort: sort);
        }
      } else {
        // Busca na API e salva no SharedPreferences
        user = await githubService.fetchUser(username);
        repositories = await githubService.fetchRepositories(username, sort: sort);
        await userPreferences.saveUser(user);
      }

      if (user == null || repositories == null) {
        throw Exception('No user data available.');
      }

      // Atualiza o estado com os dados carregados
      _stateController.add(ProfileSuccess(user, repositories));
    } catch (e) {
      _stateController.add(ProfileError('Failed to load profile: $e'));
    }
  }

  void dispose() {
    _stateController.close();
  }
}
