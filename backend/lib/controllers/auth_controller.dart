import 'package:backend_framework/backend.dart';

@ControllerInfo()
class AuthController extends BackendController {
  @Post(path: '/login')
  Map login(BackendRequest request) {
    // Take username and password.
    // If user exist in DB, it return his id
    return {};
  }

  @Post(path: '/register')
  Map register(BackendRequest request) {
    print("");
    // Take username and password.
    // Create a user in DB and return his id.
    return {};
  }
}
