import 'dart:math';

import 'package:backend/backend.dart';
import 'package:backend/errors/api_error.dart';

import 'test_controller.dart';

void main(List<String> arguments) {
  Backend backend = Backend();

  backend.addError(
    errorCode: "math:add_fail",
    message: "Addition failed %s + %s",
    constructor: ApiError.new,
  );

  backend.registerController(DocumentController());

  backend.start();
}
