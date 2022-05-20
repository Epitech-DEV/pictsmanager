import 'package:mongo_dart/mongo_dart.dart';

class Album {
  ObjectId? id;
  ObjectId owner;
  String name;
  List<ObjectId> pictures;
  DateTime createdAt;
  Album({
    this.id,
    required this.owner,
    required this.name,
    required this.createdAt,
    required this.pictures,
  });

  factory Album.fromJson(Map<String, dynamic> body) {
    List<ObjectId> pictures = List<ObjectId>.from(
      body["pictures"].map(
        (tag) => tag as ObjectId,
      ),
    );
    return Album(
      id: body["_id"] as ObjectId,
      owner: body["owner"] as ObjectId,
      name: body["name"],
      pictures: pictures,
      createdAt: body["createdAt"],
    );
  }

  Map<String, dynamic> toMongo() {
    return {
      "owner": owner,
      "name": name,
      "pictures": pictures,
      "createdAt": createdAt,
    };
  }

  Map<String, dynamic> toJson() {
    List<String> pictures = List<String>.from(
      this.pictures.map(
            (picture) => picture.toHexString(),
          ),
    );
    return {
      "id": id!.toHexString(),
      "owner": owner.toHexString(),
      "name": name,
      "pictures": pictures,
      "date": createdAt.toString(),
    };
  }
}
