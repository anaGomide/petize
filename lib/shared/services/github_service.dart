import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/repository_model.dart';
import '../models/user_model.dart';

class GitHubService {
  final String baseUrl = 'https://api.github.com';

  // Fetch User
  Future<User> fetchUser(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$username'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return User.fromJson(json); // Converte JSON para objeto User
    } else {
      throw Exception('User not found');
    }
  }

  // Fetch Repositories
  Future<List<Repository>> fetchRepositories(String username, {String sort = 'created'}) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$username/repos?sort=$sort'));

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List;
      return jsonList.map((json) => Repository.fromJson(json)).toList(); // Converte cada item em Repository
    } else {
      throw Exception('Repositories not found');
    }
  }
}
