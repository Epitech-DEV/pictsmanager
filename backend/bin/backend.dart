import 'package:backend/controllers/auth_controller.dart';
// import 'package:backend_framework/backend.dart';
import 'package:postgres/postgres.dart';

void main(List<String> arguments) async {
  // Backend backend = Backend();

var connection = PostgreSQLConnection("localhost", 5432, "database", username: "database", password: "database");
await connection.open();


  // backend.registerController(AuthController());

  // backend.start();
}
