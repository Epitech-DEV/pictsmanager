import 'package:backend/helper/env.dart';
import 'package:cobalt/core/service/backend_service.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Mongo with BackendServiceMixin {
  static late Db db;

  /// Establish connection to MongoDB.
  static Future<void> start() async {
    String username = EnvHelper.read("DB_USERNAME") ?? "root";
    String password = EnvHelper.read("DB_USERNAME_PASSWORD") ?? "7ZiCx3x14BpWOCRH";
    String name = EnvHelper.read("DB_NAME") ?? "picturesmanager";
    db = await Db.create("mongodb+srv://$username:$password@cluster0.muumj.mongodb.net/$name?retryWrites=true&w=majority");
    await db.open();  
  }
}
