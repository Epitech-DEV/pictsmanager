import 'package:backend/repositories/user.dart';
import 'package:backend/services/auth.dart';
import 'package:cobalt/backend.dart';

@ControllerInfo()
class AuthController with BackendControllerMixin {
  @Post(path: '/register')
  Future<Map> register(BackendRequest request) async {
    AuthService service = backend.getService<AuthService>()!;
    UserRepository repository = backend.getService<UserRepository>()!;
    String username = request.get(ParamsType.body, "username");
    String password = request.get(ParamsType.body, "password");

    if (password.length < 8 || password.contains(" ")) {
      backend.throwError("auth:password");
    }
    if (password.length < 2 || !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username)) {
      backend.throwError("auth:register:username");
    }
    if (await repository.exist(username)) {
      backend.throwError("auth:register:username:exist");
    }

    String jwt = await service.register(username, password);
    return {"accessToken": jwt};
  }

  @Post(path: '/login')
  Future<Map> login(BackendRequest request) async {
    AuthService service = backend.getService<AuthService>()!;
    String username = request.get(ParamsType.body, "username");
    String password = request.get(ParamsType.body, "password");

    String jwt = await service.login(username, password);
    return {"accessToken": jwt};
  }
}
