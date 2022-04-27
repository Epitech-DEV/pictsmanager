import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Authentification {
  static String jwt = "";

  static Future<Object> login() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      switch (response.statusCode) {
        case 401:
          throw Exception('Invalid information');
        case 500:
          throw Exception('Internal server error');
        default:
          throw Exception('Failed to login');
      }
    }
  }

  static Future<Object> register() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      switch (response.statusCode) {
        case 401:
          throw Exception('Invalid information');
        case 500:
          throw Exception('Internal server error');
        default:
          throw Exception('Failed to register');
      }
    }
  }
}
