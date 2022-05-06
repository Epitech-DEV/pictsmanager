import 'dart:io';
import 'package:backend/helper/env.dart';
import 'package:encrypt/encrypt.dart';

class EncryptHelper {
  static Encrypter encrypter = Encrypter(
    AES(
      Key.fromUtf8(
          EnvHelper.read("VAULT_SECRET") ?? "32.............................."),
    ),
  );

  static String encrypt(String password) {
    final encrypted = encrypter.encrypt(password, iv: IV.fromLength(16));
    return encrypted.base64;
  }

  static bool match(String password, String encrypted) {
    final decrypted = encrypter.decrypt64(encrypted, iv: IV.fromLength(16));
    return password == decrypted;
  }
}
