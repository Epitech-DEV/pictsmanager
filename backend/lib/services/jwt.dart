import 'package:backend/helper/env.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JWTService {
  static String generate(String id) {
    return JWT(
      {
        "id": id,
      },
    ).sign(
      SecretKey(EnvHelper.read("JWT_SECRET") ?? "mySecret"),
    );
  }
}
