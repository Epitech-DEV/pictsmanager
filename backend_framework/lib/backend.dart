import 'package:backend_framework/annotations/backend_annotations.dart';

import 'utils/reflect.dart';

import 'package:backend_framework/core/controller/backend_controller.dart';
import 'package:backend_framework/errors/backend_error.dart';
import 'package:backend_framework/errors/error_manager.dart';
import 'package:backend_framework/event/event_emitter.dart';
import 'package:backend_framework/network/entrypoint.dart';
import 'package:backend_framework/network/router.dart';
import 'backend_error_codes.dart';

export 'package:backend_framework/annotations/backend_annotations.dart';
export 'package:backend_framework/core/controller/backend_controller.dart';
export 'package:backend_framework/core/backend_request.dart';
export 'package:backend_framework/event/event.dart';
export 'package:backend_framework/errors/errors.dart';

class Backend extends EventEmitter with ErrorManagerMixin {
  late final Router _router;
  late final Entrypoint _entrypoint;
  final ErrorManager errorManager = ErrorManager();

  Backend() {
    _router = Router(this);
    _entrypoint = Entrypoint(this, _router);

    loadErrorCodes(errorManager);
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

  void registerController(BackendController controller) {
    controller.init(backend: this);

    InstanceMirror mirror = reflect(controller);
    Map<Symbol, MethodMirror> members = mirror.type.instanceMembers;

    ControllerInfo? controllerInfo = Reflect.getControllerAnnotation(mirror);

    String controllerName = MirrorSystem.getName(mirror.type.simpleName);

    if (controllerName.endsWith('Controller')) {
      controllerName = controllerName.substring(
        0,
        controllerName.length - 'Controller'.length,
      );
    }

    for (MapEntry<Symbol, MethodMirror> entry in members.entries) {
      List<RouteAnnotation> annotations =
          Reflect.listRouteAnnotations(entry.value);

      if (annotations.isEmpty) {
        continue;
      }

      if (!Reflect.isValidRouteMethod(entry.value)) {
        throw Exception(
          'Route method "${entry.key}" of ${controller.runtimeType.toString()} instance should match Function(BackendRequest)',
        );
      }

      for (RouteAnnotation annotation in annotations) {
        List<String> path = [];

        path.add(controllerInfo?.path ?? controllerName.toLowerCase());
        path.add(annotation.path ?? '');

        final String buildedPath = path
            .map((e) {
              if (e.startsWith('/')) {
                return e.substring(1);
              }
              return e;
            })
            .where((element) => element.isNotEmpty)
            .join('/');

        print("Add route ${annotation.verb} /$buildedPath");

        _router.add(
          verb: annotation.verb,
          path: "/$buildedPath",
          handler: mirror.getField(entry.key).reflectee as RouteHandler,
          controller: controllerName.toLowerCase(),
          action: MirrorSystem.getName(entry.value.simpleName).toLowerCase(),
        );
      }
    }
  }
}
