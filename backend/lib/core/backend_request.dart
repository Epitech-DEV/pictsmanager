import 'dart:convert';
import 'dart:io';

import 'package:backend/core/backend_response.dart';

enum ParamsType { query, body, params }

class PrivateBackendRequest extends BackendRequest {
  PrivateBackendRequest(HttpRequest request) : super(request);

  void setBody(String body) {
    _body = body;
    if (body.isNotEmpty) {
      _bodyParams = jsonDecode(body) as Map<String, dynamic>;
    }
  }

  void setParams(Map<String, String> params) {
    _params = params;
  }
}

class BackendRequest {
  String? _body;
  Map<String, dynamic>? _bodyParams;
  Map<String, String>? _params;
  final HttpRequest _request;
  late final BackendResponse _response;

  BackendRequest(this._request) {
    _response = BackendResponse(_request.response);
  }

  BackendResponse get response => _response;
  HttpRequest get originalRequest => _request;
  String? get bodyString => _body;
  Map<String, dynamic>? get body => _bodyParams;
  Map<String, String>? get params => _params;
  String get method => _request.method;
  Map<String, String> get queryParams => originalRequest.uri.queryParameters;

  bool _shouldBeDefaulted(ParamsType type, String name) {
    switch (type) {
      case ParamsType.query:
        return queryParams[name] == null;
      case ParamsType.body:
        return body == null || body![name] == null;
      case ParamsType.params:
        return params == null || params![name] == null;
      default:
        return true;
    }
  }

  T? _parse<T>(String value) {
    switch (T) {
      case Map<String, dynamic>:
        return jsonDecode(value) as T?;
      case List<dynamic>:
        return jsonDecode(value) as T?;
      case bool:
        return (value == 'true') as T?;
      case String:
        return value as T?;
      case double:
        return double.tryParse(value) as T?;
      case int:
        return int.tryParse(value) as T?;
      default:
        return null;
    }
  }

  T _expected<T>(ParamsType paramType, String name, T? value) {
    if (value == null) {
      throw Exception(
        'Expected ${T.toString()} for parameter "$name" but got "${_stringifyValue(paramType, name)}"',
      );
    }
    return value;
  }

  String _stringifyValue(ParamsType paramType, String name) {
    switch (paramType) {
      case ParamsType.query:
        return queryParams[name] ?? '';
      case ParamsType.body:
        return body != null && body![name] != null
            ? body![name]!.toString()
            : '';
      case ParamsType.params:
        return params != null && params![name] != null
            ? params![name]!.toString()
            : '';
      default:
        return '';
    }
  }

  T? _value<T>(ParamsType paramType, String name) {
    switch (paramType) {
      case ParamsType.query:
        return queryParams[name] as T;
      case ParamsType.body:
        return body != null && body![name] != null ? body![name] as T : null;
      case ParamsType.params:
        return params != null && params![name] != null
            ? _parse<T>(params![name]!)
            : null;
      default:
        return null;
    }
  }

  T? get<T>(ParamsType paramType, String name, {T? defaultValue}) {
    if (_shouldBeDefaulted(paramType, name)) {
      return defaultValue;
    }

    return _expected<T>(
      paramType,
      name,
      _value(paramType, name),
    );
  }
}
