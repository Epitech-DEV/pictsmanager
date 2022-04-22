import 'package:backend_framework/errors/backend_error.dart';

class BadRequestError extends BackendError {
  BadRequestError(
    String errorCode,
    String message,
  ) : super(
          statusCode: 400,
          errorCode: errorCode,
          message: message,
          type: 'BadRequestError',
          stackTrace: StackTrace.current,
        );
}
