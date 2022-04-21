export 'dart:mirrors';
import 'dart:mirrors';
import 'package:backend/annotations/backend_annotations.dart';
import 'package:backend/core/backend_request.dart';

final TypeMirror routeAnnotationType = reflectType(RouteAnnotation);
final TypeMirror controllerAnnotationType = reflectType(ControllerInfo);
final TypeMirror backendrequestType = reflectType(BackendRequest);

class Reflect {
  static List<RouteAnnotation> listRouteAnnotations(MethodMirror method) {
    return method.metadata
        .where((element) => element.type.isSubtypeOf(routeAnnotationType))
        .map((e) => e.reflectee as RouteAnnotation)
        .toList();
  }

  static bool isValidRouteMethod(MethodMirror method) {
    if (method.parameters.isEmpty) {
      return false;
    }

    return method.parameters.first.type.isSubtypeOf(backendrequestType);
  }

  static ControllerInfo? getControllerAnnotation(InstanceMirror instance) {
    final List<InstanceMirror> metadata = instance.type.metadata;
    int index = metadata.indexWhere(
        (element) => element.type.isSubtypeOf(controllerAnnotationType));

    if (index == -1) {
      return null;
    }

    return metadata[index].reflectee as ControllerInfo;
  }
}
