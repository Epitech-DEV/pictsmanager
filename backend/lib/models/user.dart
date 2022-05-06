class User {
  int id;
  String username;
  String password;

  User({required this.id, required this.username, required this.password});

  factory User.fromSQL(List<dynamic> document) {
    return User(
      id: document[0],
      username: document[1],
      password: document[2],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.toString(),
      "username": username,
      "password": password,
    };
  }
}
