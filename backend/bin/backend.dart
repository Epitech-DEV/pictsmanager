import 'package:backend/controllers/auth.dart';
import 'package:backend/services/auth.dart';
import 'package:backend/config/mongo.dart';
import 'package:cobalt/backend.dart';
void main(List<String> arguments) async {
  /// Init Server
  Backend backend = Backend();

  /// Init DB
  await Mongo.start();

  /// Init Controllers
  backend.registerController(AuthController());

  /// Init Services
  backend.registerService(AuthService());

  /// Define errors
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

  /// Start server
  backend.start();
}
