import 'package:mongo_dart/mongo_dart.dart';

class Picture {
  ObjectId? id;
  ObjectId owner;
  String name;
  List<String> tags;
  DateTime createdAt;
  String path;
  Picture({
    this.id,
    required this.owner,
    required this.name,
    required this.tags,
    required this.createdAt,
    required this.path,
  });

  factory Picture.fromJson(Map<String, dynamic> body) {
    List<String> tags = List<String>.from(
      body["tags"].map(
        (tag) => tag,
      ),
    );
    return Picture(
      id: body["_id"] as ObjectId,
      owner: body["owner"] as ObjectId,
      name: body["name"],
      tags: tags,
      createdAt: body["createdAt"] as DateTime,
      path: body["path"],
    );
  }

  Map<String, dynamic> toMongo() {
    return {
      "owner": owner,
      "name": name,
      "tags": tags,
      "createdAt": createdAt,
      "path": path,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id!.toHexString(),
      "owner": owner.toHexString(),
      "name": name,
      "tags": tags,
      "createdAt": createdAt.toString(),
      "path": path,
    };
  }
}
