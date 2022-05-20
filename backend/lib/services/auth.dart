import 'package:backend/helper/encrypt.dart';
import 'package:backend/models/user.dart';
import 'package:backend/config/mongo.dart';
import 'package:backend/services/jwt.dart';
import 'package:cobalt/core/service/backend_service.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AuthService with BackendServiceMixin {
  DbCollection users = Mongo.db.collection('users');

  Future<String> register(String username, String password) async {
    final Map<String, dynamic>? doc =
        await users.findOne({"username": username});
    if (doc != null) {
      backend.throwError("auth:register:username:exist");
    }
    final User user =
        User(username: username, password: EncryptHelper.encrypt(password));
    final WriteResult res = await users.insertOne(user.toJson());
    final ObjectId id = res.document!["_id"] as ObjectId;
    final String jwt = backend.getService<JWTService>()!.generate(
          id.toHexString(),
        );
    return jwt;
  }

  Future<String> login(String username, String password) async {
    final Map<String, dynamic>? doc =
        await users.findOne({"username": username});
    final User? user = doc == null ? null : User.fromJson(doc);
    if (doc == null || !EncryptHelper.match(password, user!.password)) {
      backend.throwError("auth:login:invalid");
    }
    final String jwt = backend.getService<JWTService>()!.generate(
          user!.id!.toHexString(),
        );
    return jwt;
  }
}
