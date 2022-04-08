import 'package:backend/errors/backend_error.dart';
import 'package:backend/errors/error_manager.dart';
import 'package:backend/network/entrypoint.dart';
import 'package:backend/network/router.dart';

import 'backend_error_codes.dart';

class Backend with ErrorManagerMixin {
  late final Router _router;
  late final Entrypoint _entrypoint;
  final ErrorManager errorManager = ErrorManager();

  Backend() {
    _router = Router(this);
    _entrypoint = Entrypoint(this, _router);

    loadErrorCodes(errorManager);
  }

  void addRoute({
    required String verb,
    required String path,
    required RouteHandler handler,
  }) {
    _router.add(verb: verb, path: path, handler: handler);
  }

  void start({int port = 8080}) async {
    await _entrypoint.listen(port: port);
  }

  @override
  void addError<T extends BackendError>({
    required String errorCode,
    required String message,
    required T Function(String, String) constructor,
  }) {
    errorManager.addError<T>(
      errorCode: errorCode,
      message: message,
      constructor: constructor,
    );
  }

  @override
  BackendError getError(String errorCode, {List<String?>? args}) {
    return errorManager.getError(errorCode, args: args);
  }

  @override
  void throwError(String errorCode, {List<String?>? args}) {
    errorManager.throwError(errorCode, args: args);
  }
}
