import 'package:mongo_dart/mongo_dart.dart';

class Picture {
  String? id;
  String owner;
  String name;
  List<String> tags;
  DateTime date;
  String path;
  Picture(
      {this.id,
      required this.owner,
      required this.name,
      required this.tags,
      required this.date,
      required this.path});

  factory Picture.fromJson(Map<String, dynamic> doc) {
    return Picture(
      id: (doc["_id"] as ObjectId).id.hexString,
      owner: doc["owner"],
      name: doc["name"],
      tags: doc["tags"],
      date: doc["date"],
      path: doc["path"],
    );
  }

  Map<String, dynamic> toJson({bool showId = true}) {
    if (showId) {
      return {
        "id": id!,
        "owner": owner,
        "name": name,
        "tags": tags,
        "date": date.toString(),
        "path": path,
      };
    }
    return {
      "owner": owner,
      "name": name,
      "tags": tags,
      "date": date.toString(),
      "path": path,
    };
  }
}
