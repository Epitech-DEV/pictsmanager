import 'package:backend/controllers/auth.dart';
import 'package:backend/repositories/user.dart';
import 'package:backend/services/auth.dart';
import 'package:backend/services/postgresql.dart';
import 'package:cobalt/backend.dart';

void main(List<String> arguments) async {
  Backend backend = Backend();

  backend.registerController(AuthController());
  backend.registerService(UserRepository());
  backend.registerService(PostgresqlService());
  backend.registerService(AuthService());
  backend.addError(
    errorCode: "auth:password",
    message: "Password doesn't match the criteria",
    constructor: BadRequestError.new,
  );
  backend.addError(
    errorCode: "auth:register:username",
    message: "Username is invalid",
    constructor: BadRequestError.new,
  );
  backend.addError(
    errorCode: "auth:register:username:exist",
    message: "Username already used",
    constructor: BadRequestError.new,
  );
  backend.addError(
    errorCode: "auth:login:invalid",
    message: "Username or password is invalid",
    constructor: BadRequestError.new,
  );
  await backend.getService<PostgresqlService>()!.start();
  backend.start();
}
