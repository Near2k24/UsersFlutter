import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';

class ApiService {
  static const String usersApi = 'https://jsonplaceholder.typicode.com/users';

  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(usersApi));

    if (response.statusCode == 200) {
      List<dynamic> usersJson = json.decode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<User> fetchUser(int id) async {
    final response = await http.get(Uri.parse('$usersApi/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> userJson = json.decode(response.body);
      return User.fromJson(userJson);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
