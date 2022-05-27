import 'package:backend/config/mongo.dart';
import 'package:backend/models/albums.dart';
import 'package:backend/models/picture.dart';
import 'package:cobalt/core/service/backend_service.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AlbumsService with BackendServiceMixin {
  DbCollection albumsCollection = Mongo.db.collection('albums');
  DbCollection picturesCollection = Mongo.db.collection('pictures');

  Future<Album> create(String owner, String name) async {
    Album album = Album(
      owner: ObjectId.parse(owner),
      name: name,
      createdAt: DateTime.now().toUtc(),
      pictures: [],
    );
    final WriteResult res = await albumsCollection.insertOne(album.toMongo());
    album.id = res.document!["_id"] as ObjectId;
    return album;
  }

  Future<List<Map>> getAll(String owner) async {
    /// Get albums with pictures (which are Object Ids)
    List<Map> albums = await albumsCollection
        .find(where
            .eq("owner", ObjectId.parse(owner))
            .sortBy("createdAt", descending: true))
        .map(
          (body) => Album.fromJson(body).toJson(),
        )
        .toList();

    /// Populate Pictures
    for (int i = 0; i < albums.length; i++) {
      /// Converting to ObjectIds
      final List<ObjectId> ids = List<String>.from(albums[i]["pictures"])
          .map((id) => ObjectId.parse(id))
          .toList();

      final fetchedPictures = await picturesCollection
          .find(where.oneFrom('_id', ids).sortBy('createdAt', descending: true))
          .map((picture) => Picture.fromJson(picture).toJson())
          .toList();
      albums[i]["pictures"] = fetchedPictures;
    }
    return albums;
  }

  Future<void> addPicture(String owner, String album, String picture) async {
    /// Miss owner rights check
    await albumsCollection.updateOne(
      {"_id": ObjectId.parse(album)},
      modify.addToSet(
        "pictures",
        ObjectId.parse(picture),
      ),
    );
  }

  Future<void> removePicture(String owner, String album, String picture) async {
    /// Miss owner rights check
    await albumsCollection.updateOne(
      {"_id": ObjectId.parse(album)},
      modify.pull(
        "pictures",
        ObjectId.parse(picture),
      ),
    );
  }
}
