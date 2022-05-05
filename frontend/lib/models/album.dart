
import 'package:frontend/models/picture.dart';

class AlbumData {
  final String name;
  final List<PictureData> pictures;
  final DateTime createdAt;

  AlbumData({
    required this.name, 
    required this.pictures,
    required this.createdAt,
  });

  factory AlbumData.fromJson(Map<String, dynamic> json) {
    return AlbumData(
      name: json['name'],
      pictures: (json['pictures'] as List<dynamic>).map((e) => PictureData.fromJson(e)).toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pictures': pictures,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}