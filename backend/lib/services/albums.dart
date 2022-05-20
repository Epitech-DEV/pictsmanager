import 'package:backend/config/mongo.dart';
import 'package:backend/models/albums.dart';
import 'package:backend/models/picture.dart';
import 'package:backend/services/pictures.dart';
import 'package:cobalt/core/service/backend_service.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AlbumsService with BackendServiceMixin {
  DbCollection albums = Mongo.db.collection('albums');

  Future<Album> create(String owner, String name) async {
    Album album = Album(
      owner: ObjectId.parse(owner),
      name: name,
      createdAt: DateTime.now().toUtc(),
      pictures: [],
    );
    final WriteResult res = await albums.insertOne(album.toMongo());
    album.id = res.document!["_id"] as ObjectId;
    return album;
  }

  Future<List<Map>> getAll(String owner) async {
    List<Map> albums = await this
        .albums
        .find(
          {"owner": ObjectId.parse(owner)},
        )
        .map(
          (body) => Album.fromJson(body).toJson(),
        )
        .toList();

    PicturesService picturesService = backend.getService<PicturesService>()!;
    for (int i = 0; i < albums.length; i++) {
      List<Map<String, dynamic>> pictures = [];

      for (String id in albums[i]["pictures"]) {
        Picture picture = Picture.fromJson(
          await picturesService.get(owner, id),
        );
        pictures.add(picture.toJson());
      }
      albums[i]["pictures"] = pictures;
    }

    albums.sort(
      (a, b) {
        return b["createdAt"].compareTo(a["createdAt"]);
      },
    );
    return albums;
  }

  Future<void> addPicture(String owner, String album, String picture) async {
    /// Miss rights check
    await albums.updateOne(
      {"_id": ObjectId.parse(album)},
      modify.addToSet(
        "pictures",
        ObjectId.parse(picture),
      ),
    );
  }

  Future<void> removePicture(String owner, String album, String picture) async {
    /// Miss rights check
    await albums.updateOne(
      {"_id": ObjectId.parse(album)},
      modify.pull(
        "pictures",
        ObjectId.parse(picture),
      ),
    );
  }
}
