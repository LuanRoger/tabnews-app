import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tabnews/src/models/user.dart';

class UserService {
  final apiUrl = 'https://www.tabnews.com.br/api/v1';

  Future<User> fetchUser(String username) async {
    final response = await http.get(
      Uri.parse('$apiUrl/users/$username'),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get public user');
    }
  }
}
