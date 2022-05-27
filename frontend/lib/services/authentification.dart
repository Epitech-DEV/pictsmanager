import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/utils/custom_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Authentification {
  static String jwt = "";

  static Future<Object> login(String username, String password) async {
    final Object body = {
      "username": username,
      "password": password,
    };
    print(body);
    final jsonResponse = await http.post(
      Uri.parse('http://192.168.1.153:8080/auth/login'),
      body: jsonEncode(body),
    );
    print(jsonResponse);
    final response = jsonDecode(jsonResponse.body);

    if (jsonResponse.statusCode == 200) {
      FlutterSecureStorage storage = const FlutterSecureStorage();
      storage.write(key: "token", value: response['result']['accessToken']);
      return response;
    } else {
      switch (jsonResponse.statusCode) {
        case 400:
          throw CustomException(
            message: 'Invalid credentials',
            errorCode: jsonResponse.statusCode,
          );
        case 500:
          throw CustomException(
            message: 'Internal server error',
            errorCode: jsonResponse.statusCode,
          );
        default:
          throw CustomException(
            message: 'Failed to login',
            errorCode: jsonResponse.statusCode,
          );
      }
    }
  }

  static Future<Object> register(String username, String password) async {
    final Object body = {
      "username": username,
      "password": password,
    };
    final jsonResponse = await http.post(
      Uri.parse('http://192.168.1.153:8080/auth/register'),
      body: jsonEncode(body),
    );
    final response = jsonDecode(jsonResponse.body);

    if (jsonResponse.statusCode == 200) {
      FlutterSecureStorage storage = const FlutterSecureStorage();
      storage.write(key: "token", value: response['result']['accessToken']);
      return response;
    } else {
      print(response.body);
      switch (response.statusCode) {
        case 400:
          throw CustomException(
            message: 'User already exists',
            errorCode: response.statusCode,
          );
        case 401:
          throw CustomException(
            message: 'Invalid information',
            errorCode: response.statusCode,
          );
        case 500:
          throw CustomException(
            message: 'Internal server error',
            errorCode: response.statusCode,
          );
        default:
          throw CustomException(
            message: 'Failed to register',
            errorCode: response.statusCode,
          );
      }
    }
  }
}
