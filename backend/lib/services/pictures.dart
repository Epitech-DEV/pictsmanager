import 'package:backend/config/mongo.dart';
import 'package:backend/models/picture.dart';
import 'package:backend/services/albums.dart';
import 'package:cobalt/core/service/backend_service.dart';
import 'package:cobalt/network/multipart_parser.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io';

class PicturesService with BackendServiceMixin {
  DbCollection picturesCollection = Mongo.db.collection('pictures');
  DbCollection albumsCollection = Mongo.db.collection('albums');
  DbCollection usersCollection = Mongo.db.collection('users');
  List<String> filesAccepted = ["png", "jpeg", "jpg"];

  Future<List<Map>> getShared(String owner) async {
    List<Map> pictures = await picturesCollection
        .find(where
            .eq("shared", ObjectId.parse(owner))
            .sortBy("createdAt", descending: true))
        .map(
      (body) {
        Picture picture = Picture.fromJson(body);
        return picture.toJson();
      },
    ).toList();
    return pictures;
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
    List<String> pictures,
    List<String> users,
  ) async {
    final List<ObjectId> picturesIds =
        pictures.map((id) => ObjectId.parse(id)).toList();

    /// Since the Front doesnt send the Ids, we have retieve them.
    final List<ObjectId> userIds = await _fetchUserIds(users);
    await picturesCollection.updateMany(
      where.eq("owner", ObjectId.parse(owner)).oneFrom("_id", picturesIds),
      {
        "\$push": {
          "shared": {"\$each": userIds}
        },
      },
    );
  }

  Future<void> removePermissions(
    String owner,
    List<String> pictures,
    List<String> users,
  ) async {
    final List<ObjectId> picturesIds =
        pictures.map((id) => ObjectId.parse(id)).toList();
    final List<ObjectId> userIds = await _fetchUserIds(users);

    await picturesCollection.updateMany(
      where.eq("owner", ObjectId.parse(owner)).oneFrom("_id", picturesIds),
      {
        "\$pull": {
          "shared": {"\$in": userIds}
        },
      },
    );
  }

  Future<void> deletePictures(String owner, List<String> ids) async {
    final List<ObjectId> objectIds =
        ids.map((id) => ObjectId.parse(id)).toList();
    await albumsCollection.updateMany(
      where.eq("owner", ObjectId.parse(owner)),
      {
        "\$pull": {
          "pictures": {"\$in": objectIds}
        }
      },
    );
    await picturesCollection.deleteMany(where.oneFrom("_id", objectIds));
  }

  Future<List<Map>> getAll(String owner) async {
    List<Map> pictures = await picturesCollection
        .find(
      where
          .eq("owner", ObjectId.parse(owner))
          .sortBy("createdAt", descending: true),
    )
        .map(
      (body) {
        Picture picture = Picture.fromJson(body);
        return picture.toJson();
      },
    ).toList();
    return pictures;
  }

  Future<List<Map>> search(
    String owner, {
    String? name,
    List<String>? tags,
    DateTime? begin,
    DateTime? end,
  }) async {
    Map<String, dynamic> options = {
      "owner": ObjectId.parse(owner),
      "name": {"\$regex": name ?? "", "\$options": "i"},
    };

    if (tags != null) {
      options["tags"] = {"\$all": tags};
    }

    if (begin != null) {
      if (end != null) {
        // Between to dates
        options["createdAt"] = {"\$gte": begin, "\$lt": end};
      } else {
        // Strict date
        options["createdAt"] = {"\$gte": begin};
      }
    }

    List<Map> pictures = await picturesCollection
        .find(options)
        .map((document) => Picture.fromJson(document).toJson())
        .toList();
    return pictures;
  }

  Future<Map<String, dynamic>> get(String owner, String id) async {
    Map<String, dynamic>? picture = await picturesCollection.findOne(
      {
        "owner": ObjectId.parse(owner),
        "_id": ObjectId.parse(id),
      },
    );

    if (picture == null) {
      backend.throwError("picture:found:file");
    }
    return picture!;
  }

  Future<Picture> upload(
    String owner,
    MultiPartPart part,
    String name,
    List<String> tags,
    List<String> albums,
  ) async {
    /// Type is PNG, JPG or JPEG ?
    String type = part.contentType!.split("/")[1];
    if (!filesAccepted.contains(type)) {
      backend.throwError("picture:upload:file");
    }

    /// Save file
    String path = Uuid().v4() + ".$type";
    File file = await File('pictures/$path').create(recursive: true);
    file.writeAsBytes(part.content);

    Picture picture = Picture(
      owner: ObjectId.parse(owner),
      name: name,
      tags: tags,
      createdAt: DateTime.now().toUtc(),
      path: path,
    );
    final WriteResult res = await picturesCollection.insertOne(
      picture.toMongo(),
    );
    picture.id = res.document!["_id"] as ObjectId;

    AlbumsService albumsService = backend.getService<AlbumsService>()!;

    for (String album in albums) {
      await albumsService.addPicture(owner, album, picture.id!.toHexString());
    }
    return picture;
  }
}
