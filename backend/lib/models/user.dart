import 'package:mongo_dart/mongo_dart.dart';

class User {
  String? id;
  String username;
  String password;

  User({this.id, required this.username, required this.password});

  factory User.fromJson(Map<String, dynamic> doc) {
    return User( 
      id: (doc["_id"] as ObjectId).id.hexString,
      username: doc["username"],
      password: doc["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
    };
  }
}
