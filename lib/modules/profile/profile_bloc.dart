import 'dart:async';
import '../../shared/models/user_model.dart';
import '../../shared/models/repository_model.dart';
import '../../shared/services/github_service.dart';
import 'profile_state.dart';

class ProfileBloc {
  final _stateController = StreamController<ProfileState>.broadcast();
  final GitHubService githubService = GitHubService();

  Stream<ProfileState> get stateStream => _stateController.stream;

  void fetchProfile(String username) async {
    _stateController.add(ProfileLoading());
    try {
      final user = await githubService.fetchUser(username);
      final repositories = await githubService.fetchRepositories(username);
      _stateController.add(ProfileSuccess(user, repositories));
    } catch (e) {
      _stateController.add(ProfileError('Failed to load profile.'));
    }
  }

  void dispose() {
    _stateController.close();
  }
}