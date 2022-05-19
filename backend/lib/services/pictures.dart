import 'package:backend/config/mongo.dart';
import 'package:backend/models/picture.dart';
import 'package:cobalt/core/service/backend_service.dart';
import 'package:cobalt/network/multipart_parser.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io';

class PicturesService with BackendServiceMixin {
  DbCollection pictures = Mongo.db.collection('pictures');
  List<String> filesAccepted = ["png", "jpeg", "jpg"];

  Future<List<Map<String, dynamic>>> get(String id) async {
    print(pictures.find({"owner": id}).toList());
    return [];
  }

  Future<Picture> upload(String owner, MultiPartPart part, String name,
      List<String> tags, List<String> albums) async {
    /// Type is PNG, JPG or JPEG ?
    String type = part.contentType!.split("/")[1];
    if (!filesAccepted.contains(type)) {
      backend.throwError("picture:upload:file");
    }

    /// Save file
    String path = Uuid().v4();
    File file = await File('pictures/$path.$type').create(recursive: true);
    file.writeAsBytes(part.content);

    Picture picture = Picture(
      owner: owner,
      name: name,
      tags: tags,
      date: DateTime.now(),
      path: path,
    );
    final WriteResult res = await pictures.insertOne(
      picture.toJson(showId: false),
    );
    final String id = (res.document!["_id"] as ObjectId).id.hexString;
    picture.id = id;
    return picture;
  }
}
