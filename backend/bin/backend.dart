import 'package:backend/config/mongo.dart';
import 'package:backend/controllers/albums.dart';
import 'package:backend/controllers/auth.dart';
import 'package:backend/controllers/pictures.dart';
import 'package:backend/services/albums.dart';
import 'package:backend/services/auth.dart';
import 'package:backend/services/jwt.dart';
import 'package:backend/services/pictures.dart';
import 'package:cobalt/backend.dart';

void main(List<String> arguments) async {
  /// Init Server
  Backend backend = Backend();

  /// Init DB
  await Mongo.start();

  /// Init Controllers
  backend.registerController(AuthController());
  backend.registerController(PicturesController());
  backend.registerController(AlbumsController());

  /// Init Services
  backend.registerService(AuthService());
  backend.registerService(PicturesService());
  backend.registerService(AlbumsService());
  backend.registerService(JWTService());

  /// Define errors
  backend.addError(
    errorCode: "auth:register:password",
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
  backend.addError(
    errorCode: "jwt:invalid",
    message: "JWT invalid",
    constructor: SecurityError.new, // Must be 401
  );
  backend.addError(
    errorCode: "picture:upload:file",
    message: "File invalid",
    constructor: BadRequestError.new,
  );
  backend.addError(
    errorCode: "picture:found:file",
    message: "File not found",
    constructor: BadRequestError.new,
  );

  backend.onPipe<AfterRequestProcessingEvent>((event) {
    //event.request.response.addHeader("Access-Control-Allow-Origin", "*");
    return event;
  });

  /// Start server
  backend.start();
}
