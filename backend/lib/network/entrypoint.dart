import 'dart:convert';
import 'dart:io';

import 'package:backend/backend.dart';
import 'package:backend/backend_module.dart';
import 'package:backend/core/backend_request.dart';
import 'package:backend/core/backend_response.dart';
import 'package:backend/network/router.dart';

class Entrypoint extends BackendModule {
  HttpServer? server;
  Router router;

  Entrypoint(Backend backend, this.router) : super(backend);

  void init() {}

  Future<void> listen({int port = 8080}) async {
    server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    print('Listening on port: $port');

    server!.listen(_onHTTPRequest);
  }

  void addDefaultHeaders(BackendRequest request, BackendResponse response) {
    response.addHeader('Content-Type', 'application/json');
    response.addHeader('Access-Control-Allow-Origin', '*');
    response.addHeader(
        'Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    response.addHeader('Access-Control-Allow-Headers',
        'Origin, X-Requested-With, Content-Type, Accept, Authorization');
    response.addHeader('Access-Control-Allow-Credentials', 'true');
  }

  void sendResponse(BackendRequest request) {
    HttpResponse response = request.response.originalResponse;

    addDefaultHeaders(request, request.response);

    if (request.response.errored) {
      response.write(jsonEncode(request.response.error!.toJson()));
      response.close();
      return;
    }

    String json = jsonEncode(request.response.result);
    response.write(json);
    response.close();
  }

  void _onHTTPRequest(HttpRequest request) {
    print('${request.method} ${request.uri}');
    PrivateBackendRequest _request = PrivateBackendRequest(request);

    Future(() async {
      String body = await utf8.decodeStream(request);
      _request.setBody(body);
      await router.execute(_request);
      sendResponse(_request);
    });
  }

  void stop() {
    server?.close();
  }
}
