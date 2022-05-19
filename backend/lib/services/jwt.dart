import 'package:backend/helper/env.dart';
import 'package:cobalt/core/backend_request.dart';
import 'package:cobalt/core/service/backend_service.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JWTService with BackendServiceMixin {
  String key = EnvHelper.read("JWT_SECRET") ?? "mySecret";

  String generate(String id) {
    return JWT(
      {
        "id": id,
      },
    ).sign(
      SecretKey(key),
    );
  }

  dynamic verify(BackendRequest request) {
    String bearer = request.headers["Authorization"]![0];
    String token = bearer.replaceAll("Bearer ", "");
    try {
      JWT jwt = JWT.verify(token, SecretKey(key));
      return jwt.payload;
    } catch (e) {
      backend.throwError("jwt:invalid");
    }
  }
}
