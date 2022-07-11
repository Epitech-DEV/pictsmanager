
import 'dart:convert';

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
    final response = await api.post('/auth/register', body: {
      'username': username,
      'password': password,
    });

    final responseBody = jsonDecode(response.body);
    String jwt = responseBody['result']['accessToken'];
    api.setJWT(jwt);
  }

  @override
  Future<void> login(String username, String password) async {    
    final response = await api.post('/auth/login', body: {
      'username': username,
      'password': password,
    });

    final responseBody = jsonDecode(response.body);
    String jwt = responseBody['result']['accessToken'];
    api.setJWT(jwt);
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