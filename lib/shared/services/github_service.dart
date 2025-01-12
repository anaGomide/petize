import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../models/repository_model.dart';
import '../models/user_model.dart';

class GitHubService {
  final String baseUrl = 'https://api.github.com';
  String? token = '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';

  GitHubService({this.token});

  // Headers com o token de autorização
  Map<String, String> get headers => {
        'Authorization': 'Bearer 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',
        'Accept': 'application/vnd.github.v3+json', // Versão da API
      };

  // Fetch User
  Future<User> fetchUser(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$username'),
      headers: headers, // Adicione os headers
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      inspect(json);
      return User.fromJson(json);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid token');
    } else {
      throw Exception('User not found');
    }
  }

  // Fetch Repositories
  Future<List<Repository>> fetchRepositories(String username, {String? sort}) async {
    // Define a URL com ou sem o parâmetro `sort`
    final url =
        sort != null && sort.isNotEmpty ? Uri.parse('$baseUrl/users/$username/repos?sort=$sort') : Uri.parse('$baseUrl/users/$username/repos');

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List;
      return jsonList.map((json) => Repository.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid token');
    } else {
      throw Exception('Repositories not found');
    }
  }
}
