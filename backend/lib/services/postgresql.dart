import 'dart:io';
import 'package:cobalt/core/service/backend_service.dart';
import 'package:postgres/postgres.dart';

class PostgresqlService with BackendServiceMixin {
  late PostgreSQLConnection database;

  /// Establish connection to PostgreSQL database.
  Future<void> start() async {
    Map<String, String> env = Platform.environment;
    String host = "localhost";
    String name = env["DB_NAME"] ?? "database";
    int port = int.parse(env["DB_PORT"] ?? "5432");
    String username = env["DB_USERNAME"] ?? "database";
    String password = env["DB_USERNAME_PASSWORD"] ?? "database";

    database = PostgreSQLConnection(
      host,
      port,
      name,
      username: username,
      password: password,
    );
    await database.open();
  }
}
