import 'dart:io';

class EnvHelper {
  static String? read(String key) {
    return Platform.environment[key];
  }
}
