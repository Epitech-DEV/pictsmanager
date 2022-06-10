import 'package:frontend/models/album.dart';

class PictureMetadata {
  String filename;
  List<String> tags;
  List<AlbumData> albums;

  PictureMetadata({
    required this.filename,
    required this.tags,
    required this.albums,
  });

  Map<String, dynamic> toJson() {
    return {
      "filename": filename,
      "tags": tags,
      "albums": albums.where((e) => e.id != null).map((e) => e.id).toList()
    };
  }
}
