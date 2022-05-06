import 'package:backend/models/user.dart';
import 'package:backend/services/postgresql.dart';
import 'package:cobalt/core/service/backend_service.dart';
import 'package:postgres/postgres.dart';

class UserRepository with BackendServiceMixin {
  Future<User?> retrieve(String username) async {
    PostgreSQLConnection database =
        backend.getService<PostgresqlService>()!.database;

    final List<dynamic> documents = await database.query(
      "SELECT * FROM Users WHERE username = (@username)",
      substitutionValues: {"username": username},
    );

    return documents.isEmpty ? null : User.fromSQL(documents[0]);
  }

  Future<bool> exist(String username) async {
    PostgreSQLConnection database =
        backend.getService<PostgresqlService>()!.database;

    final List<dynamic> documents = await database.query(
      "SELECT * FROM Users WHERE username = (@username)",
      substitutionValues: {"username": username},
    );
    return documents.isNotEmpty;
  }

  Future<User> create(String username, String password) async {
    PostgreSQLConnection database =
        backend.getService<PostgresqlService>()!.database;

    List<dynamic> documents = await database.query(
      "INSERT INTO Users(username, password) VALUES (@username, @password) RETURNING *",
      substitutionValues: {
        "username": username,
        "password": password,
      },
    );
    return User.fromSQL(documents[0]);
  }
}
