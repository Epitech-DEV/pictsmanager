class RouteAnnotation {
  final String? path;
  final String verb;

  const RouteAnnotation(
    this.verb, {
    this.path,
  });
}

class Get extends RouteAnnotation {
  const Get({String? name, String? path}) : super('GET', path: path);
}

class Post extends RouteAnnotation {
  const Post({String? name, String? path}) : super('POST', path: path);
}

class Delete extends RouteAnnotation {
  const Delete({String? name, String? path}) : super('DELETE', path: path);
}

class Put extends RouteAnnotation {
  const Put({String? name, String? path}) : super('PUT', path: path);
}

class Patch extends RouteAnnotation {
  const Patch({String? name, String? path}) : super('PATCH', path: path);
}
