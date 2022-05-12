import 'package:backend/helper/env.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JWTService {
  static String generate(int id) {
    return JWT(
      {
        "id": id.toString(),
      },
    ).sign(
      SecretKey(EnvHelper.read("JWT_SECRET") ?? "mySecret"),
    );
  }
}
