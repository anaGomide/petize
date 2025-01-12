import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/models/user_model.dart';
import 'home_state.dart';

class HomeBloc {
  final _stateController = StreamController<HomeState>();
  final _recentSearchesController = StreamController<List<String>>.broadcast();

  Stream<HomeState> get stateStream => _stateController.stream;
  Stream<List<String>> get recentSearchesStream => _recentSearchesController.stream;

  final List<String> _recentSearches = [];

  HomeBloc() {
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

  void searchUser(String query) {
    if (!_recentSearches.contains(query)) {
      if (_recentSearches.length >= 5) {
        _recentSearches.removeAt(0);
      }
      _recentSearches.add(query);
    }
    _recentSearchesController.add(_recentSearches);
    _saveRecentSearches();

    _stateController.add(HomeLoading());
    Future.delayed(const Duration(seconds: 2), () {
      if (query == "error") {
        _stateController.add(HomeError("Usuário não encontrado!"));
      } else {
        final user = User(
          login: query,
        );
        _stateController.add(HomeSuccess(user));
      }
    });
  }

  void dispose() {
    _stateController.close();
    _recentSearchesController.close();
  }
}
