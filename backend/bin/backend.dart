import 'package:backend/backend.dart';
import 'dart:mirrors';

import 'package:backend/core/backend_request.dart';

void main(List<String> arguments) {
  Backend backend = Backend();

  backend.addRoute(
    verb: 'GET',
    path: '/add/:valA/:valB',
    handler: (BackendRequest request) {
      return request.get<double>(ParamsType.params, 'valA')! +
          request.get<int>(ParamsType.params, 'valB')!;
    },
  );

  backend.start();
}
