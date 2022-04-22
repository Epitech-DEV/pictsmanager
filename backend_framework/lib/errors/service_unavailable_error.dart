import 'package:backend_framework/errors/backend_error.dart';

class ServiceUnavailableError extends BackendError {
  ServiceUnavailableError(
    String errorCode,
    String message,
  ) : super(
          statusCode: 501,
          errorCode: errorCode,
          message: message,
          type: 'ServiceUnavailableError',
          stackTrace: StackTrace.current,
        );
}
