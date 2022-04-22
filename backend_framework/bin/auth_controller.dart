import 'package:backend_framework/backend.dart';

@ControllerInfo()
class AuthController extends BackendController {
  @Post(path: '/login')
  Map login(BackendRequest request) {
    print(request.body);

    return {};
  }

  @Post(path: '/register')
  Map register(BackendRequest request) {
    return {};
  }
}
