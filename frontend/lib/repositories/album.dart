
import 'package:frontend/models/album.dart';
import 'package:frontend/models/picture.dart';

abstract class AlbumRepository {
  Future<List<AlbumData>> getUserAlbums();
  Future<AlbumData> createAlbum(String name);
}

class AlbumApiRepository extends AlbumRepository {
  @override
  Future<List<AlbumData>> getUserAlbums() {
    // TODO: implement getUserAlbums
    throw UnimplementedError();
  }
  
  @override
  Future<AlbumData> createAlbum(String name) {
    // TODO: implement createAlbum
    throw UnimplementedError();
  }
}

class AlbumInMemoryRepository extends AlbumRepository {
  final List<AlbumData> _albums = [
    AlbumData(
      name: "Album 1",
      pictures: [
        PictureData(
          name: "Picture 1",
          url: "https://picsum.photos/id/1/200/300",
          date: DateTime(2021, 3, 21),
        ),
        PictureData(
          name: "Picture 2",
          url: "https://picsum.photos/id/2/200/300",
          date: DateTime(2021, 3, 21),
        ),
        PictureData(
          name: "Picture 3",
          url: "https://picsum.photos/id/3/200/300",
          date: DateTime(2021, 3, 21),
        ),
      ],
      createdAt: DateTime(2021, 4, 21),
    ),
    AlbumData(
      name: "Album 2",
      pictures: [
        PictureData(
          name: "Picture 1",
          url: "https://picsum.photos/id/1/200/300",
          date: DateTime(2021, 3, 21),
        ),
        PictureData(
          name: "Picture 2",
          url: "https://picsum.photos/id/2/200/300",
          date: DateTime(2021, 3, 21),
        ),
        PictureData(
          name: "Picture 3",
          url: "https://picsum.photos/id/3/200/300",
          date: DateTime(2021, 3, 21),
        ),
      ],
      createdAt: DateTime(2021, 5, 21),
    ),
    AlbumData(
      name: "Album 3",
      pictures: [
        PictureData(
          name: "Picture 1",
          url: "https://picsum.photos/id/1/200/300",
          date: DateTime(2021, 3, 21),
        ),
        PictureData(
          name: "Picture 2",
          url: "https://picsum.photos/id/2/200/300",
          date: DateTime(2021, 3, 21),
        ),
        PictureData(
          name: "Picture 3",
          url: "https://picsum.photos/id/3/200/300",
          date: DateTime(2021, 3, 21),
        ),
      ],
      createdAt: DateTime(2021, 6, 21),
    ),
  ];

  @override
  Future<List<AlbumData>> getUserAlbums() {
    return Future.delayed(
      const Duration(seconds: 2),
      () => _albums,
    );
  }
  
  @override
  Future<AlbumData> createAlbum(String name) {
    AlbumData newAlbum = AlbumData(
      name: name,
      pictures: [],
      createdAt: DateTime.now(),
    );

    _albums.add(newAlbum);

    return Future.delayed(
      const Duration(seconds: 2),
      () => newAlbum,
    );
  }
  
}