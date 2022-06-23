import 'dart:convert';
import 'dart:io';

import 'package:backend/extensions/list_extension.dart';
import 'package:backend/models/picture.dart';
import 'package:backend/services/jwt.dart';
import 'package:backend/services/pictures.dart';
import 'package:cobalt/backend.dart';
import 'package:cobalt/network/http_stream.dart';
import 'package:cobalt/network/multipart_parser.dart';

@ControllerInfo()
class PicturesController with BackendControllerMixin {
  @Get(path: '/shared')
  Future<List<Map>> getShared(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)["id"];

    final List<Map> shared =
        await backend.getService<PicturesService>()!.getShared(owner);
    return shared;
  }

  @Post(path: '/share')
  Future<Map> addPermissions(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)["id"];
    List<String> pictures = List<String>.from(
      request.get(ParamsType.body, "pictures"),
    );
    List<String> users = List<String>.from(
      request.get(ParamsType.body, "users"),
    );
    await backend
        .getService<PicturesService>()!
        .addPermissions(owner, pictures, users);
    return {};
  }

  @Post(path: '/unshare')
  Future<Map> removePermissions(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)["id"];
    List<String> pictures = List<String>.from(
      request.get(ParamsType.body, "pictures"),
    );
    List<String> users = List<String>.from(
      request.get(ParamsType.body, "users"),
    );
    await backend
        .getService<PicturesService>()!
        .removePermissions(owner, pictures, users);
    return {};
  }

  @Get(path: '/download/:path')
  HttpStream download(BackendRequest request) {
    String path = request.get<String>(ParamsType.params, 'path')!;
    String fileType = path.split('.')[1];

    return HttpStream(
      File('./pictures/$path').openRead(),
      contentType: 'image/$fileType',
    );
  }

  @Get(path: '/')
  Future<List> getAll(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)['id'];

    List<Map> picture =
        await backend.getService<PicturesService>()!.getAll(owner);
    return picture;
  }

  @Post(path: '/')
  Future<Map> delete(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)['id'];
    List<String> pictures =
        List<String>.from(request.get(ParamsType.body, 'pictures'));
    await backend
        .getService<PicturesService>()!
        .deletePictures(owner, pictures);
    return {};
  }

  @Post(path: '/search')
  Future<List<Map>> search(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)["id"];

    String? tags = request.get(ParamsType.body, "tags");
    String? name = request.get(ParamsType.body, "name");
    String? begin = request.get(ParamsType.body, "begin");
    String? end = request.get(ParamsType.body, "end");

    List<String>? tagsSplitted;
    DateTime? beginDate;
    DateTime? endDate;

    if (tags != null) {
      tagsSplitted = tags.split(",");
    }

    if (begin != null) {
      beginDate = DateTime.parse(begin);
    }

    if (end != null) {
      endDate = DateTime.parse(end);
    }

    List<Map> pictures = await backend.getService<PicturesService>()!.search(
          owner,
          name: name,
          begin: beginDate,
          end: endDate,
          tags: tagsSplitted,
        );

    return pictures;
  }

  @Get(path: '/:id')
  Future<Map> get(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)['id'];
    String id = request.get<String>(ParamsType.params, 'id')!;

    Map picture = await backend.getService<PicturesService>()!.get(owner, id);
    return picture;
  }

  @Post(path: '/upload')
  Future<Map> upload(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)['id'];

    /// File exist ?
    if (request.parts == null || request.parts!.isEmpty) {
      backend.throwError('picture:upload:file');
    }

    final MultiPartPart? filePart = request.parts!
        .find((element) => element.name == 'file' && element.isFile);
    final MultiPartPart? metadataPart =
        request.parts!.find((element) => element.name == 'metadata');

    if (filePart == null) {
      backend.throwError('picture:upload:file');
    }

    if (metadataPart == null) {
      backend.throwError('picture:upload:missing_metadata');
    }

    Map<String, dynamic> description =
        jsonDecode(metadataPart!.contentAsString());

    /// Format description
    String name = filePart!.filename ?? DateTime.now().toString();
    List<String> tags = (description['tags'] as List<dynamic>).cast<String>();
    List<String> albums =
        (description['albums'] as List<dynamic>).cast<String>();
    Picture picture = await backend
        .getService<PicturesService>()!
        .upload(owner, filePart, name, tags, albums);
    return picture.toJson();
  }
}
