
import 'package:frontend/models/album.dart';
import 'package:frontend/models/picture.dart';

class SharedData {
  final List<AlbumData> albums;
  final List<PictureData> pictures;

  SharedData({
    required this.albums,
    required this.pictures,
  });
}