import 'package:mongo_dart/mongo_dart.dart';

class User {
  ObjectId? id;
  String username;
  String password;

  User({this.id, required this.username, required this.password});

  factory User.fromJson(Map<String, dynamic> body) {
    return User(
      id: body["_id"] as ObjectId,
      username: body["username"],
      password: body["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
    };
  }
}
