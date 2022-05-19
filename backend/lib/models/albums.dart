import 'package:mongo_dart/mongo_dart.dart';

class Album {
  String? id;
  String owner;
  String name;
  List<String> pictures;
  DateTime date;
  Album({
    this.id,
    required this.owner,
    required this.name,
    required this.date,
    required this.pictures,
  });

  factory Album.fromJson(Map<String, dynamic> doc) {
    List<String> pictures =
        List<String>.from(doc["pictures"].map((tag) => tag));

    return Album(
      id: (doc["_id"] as ObjectId).id.hexString,
      owner: doc["owner"],
      name: doc["name"],
      pictures: pictures,
      date: doc["date"],
    );
  }

  Map<String, dynamic> toJson({bool showId = true}) {
    if (showId) {
      return {
        "id": id!,
        "owner": owner,
        "name": name,
        "pictures": pictures,
        "date": date.toString(),
      };
    }
    return {
      "owner": owner,
      "name": name,
      "pictures": pictures,
      "date": date.toString(),
    };
  }
}
