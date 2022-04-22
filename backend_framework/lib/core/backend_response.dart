import 'dart:io';

import 'package:backend_framework/errors/backend_error.dart';

class BackendResponse {
  late final HttpResponse _response;
  dynamic _result;
  BackendError? _error;
  bool errored = false;

  BackendResponse(HttpResponse response) {
    _response = response;
  }

  get originalResponse => _response;

  set status(int code) {
    _response.statusCode = code;
  }

  set result(dynamic _result) {
    this._result = _result;
    status = 200;
  }

  get result => _result;

  set error(BackendError? exception) {
    if (exception == null) {
      return;
    }

    errored = true;
    _error = exception;
    _response.statusCode = exception.statusCode;
  }

  void addHeader(String header, String value) {
    _response.headers.add(header, value);
  }

  void addHeaders(Map<String, String> headers) {
    headers.forEach((key, value) {
      _response.headers.add(key, value);
    });
  }

  BackendError? get error => _error;
}
