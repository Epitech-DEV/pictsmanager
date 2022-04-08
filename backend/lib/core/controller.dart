import 'backend_request.dart';

typedef RouteHandler = dynamic Function(BackendRequest);

mixin Controller {
  Map<String, RouteHandler> initRoutes();
}
