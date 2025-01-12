import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class UserPreferencesService {
  /// Salva os dados do usuário no SharedPreferences.
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('login', user.login);
    prefs.setString('avatar_url', user.avatarUrl);
    prefs.setString('name', user.name ?? '');
  }

  /// Carrega os dados do usuário do SharedPreferences.
  Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final login = prefs.getString('login');
    if (login == null) return null;

    return User(
      login: login,
      avatarUrl: prefs.getString('avatar_url')!,
      name: prefs.getString('name'),
    );
  }

  /// Limpa os dados do usuário do SharedPreferences.
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
