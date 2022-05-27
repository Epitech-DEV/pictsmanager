import 'dart:convert';
import 'dart:io';

import 'package:backend/models/picture.dart';
import 'package:backend/services/jwt.dart';
import 'package:backend/services/pictures.dart';
import 'package:cobalt/backend.dart';
import 'package:cobalt/network/http_stream.dart';
import 'package:cobalt/network/multipart_parser.dart';

@ControllerInfo()
class PicturesController with BackendControllerMixin {
  @Get(path: '/download/:path')
  HttpStream download(BackendRequest request) {
    String path = request.get<String>(ParamsType.params, "path")!;
    String fileType = path.split('.')[1];
    HttpStream stream = HttpStream(
      File('./pictures/$path').openRead(),
      contentType: 'image/$fileType',
    );
    return stream;
  }

  @Get(path: '/')
  Future<List> getAll(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)["id"];

    List<Map> picture =
        await backend.getService<PicturesService>()!.getAll(owner);
    return picture;
  }

  @Get(path: '/:id')
  Future<Map> get(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)["id"];
    String id = request.get<String>(ParamsType.params, "id")!;

    Map picture = await backend.getService<PicturesService>()!.get(owner, id);
    return picture;
  }

  @Post(path: '/upload')
  Future<Map> upload(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)["id"];

    final List<MultiPartPart>? parts = request.parts;

    /// File exist ?
    if (parts == null || parts.isEmpty || !parts[0].isFile) {
      backend.throwError("picture:upload:file");
    }

    MultiPartPart part = parts![0];
    Map<String, dynamic> description = jsonDecode(parts[1].contentAsString());

    /// Format description
    String name = description["name"];
    List<String> tags = List<String>.from(
      description["tags"].map((tag) => tag),
    );
    List<String> albums = List<String>.from(
      description["albums"].map((tag) => tag),
    );
    Picture picture = await backend
        .getService<PicturesService>()!
        .upload(owner, part, name, tags, albums);
    return picture.toJson();
  }
}
