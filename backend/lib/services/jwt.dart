import 'dart:io';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JWTService {
  static String generate(int id) {
    Map<String, String> env = Platform.environment;
    return JWT(
      {
        "id": id.toString(),
      },
    ).sign(
      SecretKey(env["JWT_SECRET"] ?? "mySecret"),
    );
  }
}
