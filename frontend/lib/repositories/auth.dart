
import 'dart:convert';

import 'package:frontend/shared/error.dart';
import 'package:frontend/repositories/api.dart';

abstract class AuthRepository {
  Future<void> register(String username, String password);
  Future<void> login(String username, String password);
  bool isLoggedIn();
  void logout();
}

class AuthApiRepository extends AuthRepository {
  late ApiDatasource api;

  AuthApiRepository() {
    api = ApiDatasource.instance;
  }

  @override
  Future<void> register(String username, String password) async {
    final response = await api.post('/register', body: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      String jwt = responseBody['result']['accessToken'];
      api.setJWT(jwt);
    } else {
      late String message;
      
      switch (response.statusCode) {
        case 400:
          message = 'Invalid username or password';
          break;
        default:
          message = 'Network error';
          break;
      }

      throw ApiError(
        code: response.statusCode,
        message: message,
      );
    }
  }

  @override
  Future<void> login(String username, String password) async {
    final response = await api.post('/register', body: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      String jwt = body['result']['accessToken'];
      api.setJWT(jwt);
    } else {
      late String message;
      
      switch (response.statusCode) {
        case 400:
          message = 'User already exists';
          break;
        case 401:
          message = 'Invalid information';
          break;
        default:
          message = 'Network error';
          break;
      }

      throw ApiError(
        code: response.statusCode,
        message: message,
      );
    }
  }

  @override
  bool isLoggedIn() {
    return api.jwt != null;
  }
  
  @override
  void logout() {
    api.clearJWT();
  }
}