import 'package:backend/config/mongo.dart';
import 'package:backend/models/albums.dart';
import 'package:backend/models/picture.dart';
import 'package:cobalt/core/service/backend_service.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AlbumsService with BackendServiceMixin {
  DbCollection albumsCollection = Mongo.db.collection('albums');
  DbCollection picturesCollection = Mongo.db.collection('pictures');
  DbCollection usersCollection = Mongo.db.collection('users');

  Future<List<Map>> getShared(String owner) async {
    List<Map> albums = await albumsCollection
        .find(where
            .eq("shared", ObjectId.parse(owner))
            .sortBy("createdAt", descending: true))
        .map(
      (body) {
        Album album = Album.fromJson(body);
        return album.toJson();
      },
    ).toList();

    /// Populate Pictures
    for (int i = 0; i < albums.length; i++) {
      albums[i]["pictures"] = await _populate(albums[i]);
    }
    return albums;
  }

  Future<List<ObjectId>> _fetchUserIds(List<String> usernames) async {
    final List<Map> usersFetched = await usersCollection
        .find(
          where.oneFrom("username", usernames),
        )
        .toList();
    final List<ObjectId> userIds = usersFetched
        .map(
          (e) => e["_id"] as ObjectId,
        )
        .toList();
    return userIds;
  }

  Future<void> addPermissions(
    String owner,
    List<String> albums,
    List<String> users,
  ) async {
    final List<ObjectId> albumsIds =
        albums.map((id) => ObjectId.parse(id)).toList();

    /// Since the Front doesnt send the Ids, we have retieve them.
    final List<ObjectId> userIds = await _fetchUserIds(users);
    await albumsCollection.updateMany(
      where.eq("owner", ObjectId.parse(owner)).oneFrom("_id", albumsIds),
      {
        "\$push": {
          "shared": {"\$each": userIds}
        },
      },
    );
  }

  Future<void> removePermissions(
    String owner,
    List<String> albums,
    List<String> users,
  ) async {
    final List<ObjectId> albumsIds =
        albums.map((id) => ObjectId.parse(id)).toList();
    final List<ObjectId> userIds = await _fetchUserIds(users);

    await albumsCollection.updateMany(
      where.eq("owner", ObjectId.parse(owner)).oneFrom("_id", albumsIds),
      {
        "\$pull": {
          "shared": {"\$in": userIds}
        },
      },
    );
  }

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

  Future<void> deleteAlbum(String owner, String id) async {
    await albumsCollection.deleteOne(
      where.eq("_id", ObjectId.parse(id)).eq("owner", ObjectId.parse(owner)),
    );
  }

  Future<void> deletePictures(
      String owner, String albumId, List<String> pictureIds) async {
    final List<ObjectId> objectIds =
        pictureIds.map((id) => ObjectId.parse(id)).toList();
    await albumsCollection.updateMany(
      where
          .eq("owner", ObjectId.parse(owner))
          .eq("_id", ObjectId.parse(albumId)),
      {
        "\$pull": {
          "pictures": {"\$in": objectIds}
        }
      },
    );
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
      albums[i]["pictures"] = await _populate(albums[i]);
    }

    return albums;
  }

  /// Populate pictures in album
  Future<List<Map>> _populate(Map albums) async {
    final List<ObjectId> ids = List<String>.from(albums["pictures"])
        .map((id) => ObjectId.parse(id))
        .toList();

    final List<Map> fetchedPictures = await picturesCollection
        .find(where.oneFrom('_id', ids).sortBy('createdAt', descending: true))
        .map((picture) => Picture.fromJson(picture).toJson())
        .toList();

    return fetchedPictures;
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
