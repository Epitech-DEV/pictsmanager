import 'package:backend/helper/encrypt.dart';
import 'package:backend/models/user.dart';
import 'package:backend/repositories/user.dart';
import 'package:backend/services/jwt.dart';
import 'package:cobalt/core/service/backend_service.dart';

class AuthService with BackendServiceMixin {
  Future<String> register(String username, String password) async {
    UserRepository repository = backend.getService<UserRepository>()!;
    final User user =
        await repository.create(username, EncryptHelper.encrypt(password));
    final String jwt = JWTService.generate(user.id);
    return jwt;
  }

  Future<String> login(String username, String password) async {
    UserRepository repository = backend.getService<UserRepository>()!;
    final User? user = await repository.retrieve(username);

    if (user == null || !EncryptHelper.match(password, user.password)) {
      backend.throwError("auth:login:invalid");
    }
    final String jwt = JWTService.generate(user!.id);
    return jwt;
  }
}
