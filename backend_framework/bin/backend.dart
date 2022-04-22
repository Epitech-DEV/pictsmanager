import 'package:backend_framework/backend.dart';

import 'auth_controller.dart';

void main(List<String> arguments) {
  Backend backend = Backend();

  backend.registerController(AuthController());

  backend.start();
}
