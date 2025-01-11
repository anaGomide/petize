import 'dart:async';

import '../../shared/services/github_service.dart';
import 'home_state.dart';

class HomeBloc {
  final _stateController = StreamController<HomeState>.broadcast();
  final GitHubService githubService = GitHubService();

  Stream<HomeState> get stateStream => _stateController.stream;

  void searchUser(String username) async {
    _stateController.add(HomeLoading());
    try {
      final user = await githubService.fetchUser(username);
      _stateController.add(HomeSuccess(user));
    } catch (e) {
      _stateController.add(HomeError('User not found.'));
    }
  }

  void dispose() {
    _stateController.close();
  }
}
