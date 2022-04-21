import 'package:backend/backend.dart';

class BackendController {
  late Backend backend;

  void init({required Backend backend}) async {
    this.backend = backend;
  }
}
