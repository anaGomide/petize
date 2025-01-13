import 'dart:async';

import 'package:petize/modules/profile/profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/models/repository_model.dart';
import '../../shared/models/user_model.dart';
import '../../shared/services/github_service.dart';
import '../../shared/services/user_preferences_service.dart';

class ProfileBloc {
  final _stateController = StreamController<ProfileState>.broadcast();
  final _recentSearchesController = StreamController<List<String>>.broadcast();

  final GitHubService githubService = GitHubService();
  final UserPreferencesService userPreferences = UserPreferencesService();

  final List<String> _recentSearches = [];

  Stream<ProfileState> get stateStream => _stateController.stream;
  Stream<List<String>> get recentSearchesStream => _recentSearchesController.stream;

  ProfileBloc() {
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    _recentSearches.addAll(prefs.getStringList('recent_searches') ?? []);
    _recentSearchesController.add(_recentSearches);
  }

  Future<void> _saveRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', _recentSearches);
  }

  void addSearch(String query) {
    if (!_recentSearches.contains(query)) {
      if (_recentSearches.length >= 5) {
        _recentSearches.removeAt(0);
      }
      _recentSearches.add(query);
    }
    _recentSearchesController.add(_recentSearches);
    _saveRecentSearches();
  }

  Future<void> fetchProfile(String username, {String? sort}) async {
    if (username.isNotEmpty) {
      addSearch(username);
    }

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
        user = await githubService.fetchUser(username);
        repositories = await githubService.fetchRepositories(username, sort: sort);
        await userPreferences.saveUser(user);
      }

      if (user == null || repositories == null) {
        throw Exception('No user data available.');
      }

      _stateController.add(ProfileSuccess(user, repositories));
    } catch (e) {
      _stateController.add(ProfileError('Failed to load profile: $e'));
    }
  }

  void dispose() {
    _stateController.close();
    _recentSearchesController.close();
  }
}
