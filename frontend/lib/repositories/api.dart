import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/shared/error.dart';
import 'package:http/http.dart' as http;

class ApiDatasource {
  ApiDatasource._();

  // TODO: setup your own API path here
  static const String _baseUrl = 'http://10.101.254.6:8080';

  static ApiDatasource? _instance;
  static FlutterSecureStorage? _storage;

  static ApiDatasource get instance {
    _instance ??= ApiDatasource._();
    _storage ??= const FlutterSecureStorage();
    return _instance!;
  }

  String? jwt;
  Map<String, String>? _headers;

  void loadJWT() async {
    jwt = await _storage?.read(key: 'jwt');
    setAuthHeader(jwt);
  }

  void setJWT(String jwt) async {
    this.jwt = jwt;
    setAuthHeader(jwt);
    await _storage?.write(key: 'jwt', value: jwt);
  }

  void clearJWT() async {
    jwt = null;
    setAuthHeader(jwt);
    await _storage?.delete(key: 'jwt');
  }

  void setAuthHeader(String? jwt) {
    if (jwt != null) {
      _headers ??= {
        'Authorization': 'Bearer $jwt',
      };
    } else {
      _headers = null;
    }
  }

  Future<http.Response> get(String path) async {
    final response = await http.get(Uri.parse('$_baseUrl$path'), headers: _headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiError.fromJson(jsonDecode(response.body)['error']);
    }

    return Future.value(response);
  }

  Future<http.Response> post(String path, {Map<String, dynamic>? body}) async {
    final encodedBody = jsonEncode(body);
    final response = await http.post(Uri.parse('$_baseUrl$path'), body: encodedBody, headers: _headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiError.fromJson(jsonDecode(response.body)['error']);
    }

    return Future.value(response);
  }

  Future<http.Response> put(String path, {Map<String, String>? body}) async {
    final encodedBody = jsonEncode(body);
    final response = await http.put(Uri.parse('$_baseUrl$path'), body: encodedBody, headers: _headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiError.fromJson(jsonDecode(response.body)['error']);
    }

    return Future.value(response);
  }

  Future<http.Response> delete(String path) async {
    final response = await http.delete(Uri.parse('$_baseUrl$path'), headers: _headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiError.fromJson(jsonDecode(response.body)['error']);
    }

    return Future.value(response);
  }

  Future<http.StreamedResponse> multipart(String path, List<http.MultipartFile> parts) async {
    final uri = Uri.parse('$_baseUrl$path');

    final request = http.MultipartRequest('POST', uri);
    request.files.addAll(parts);

    final response = await request.send();

    if (response.statusCode == 500) {
      throw ApiError(
        statusCode: response.statusCode,
        message: 'Internal server error',
      );
    }

    return Future.value(response);
  }
}