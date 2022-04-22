import 'package:backend_framework/backend.dart';

class BackendController {
  late Backend backend;

  void init({required Backend backend}) async {
    this.backend = backend;
  }
}
