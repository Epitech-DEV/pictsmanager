
import 'dart:convert';

import 'package:frontend/models/album.dart';
import 'package:frontend/repositories/api.dart';

import '../models/picture.dart';

abstract class AlbumRepository {
  Future<List<AlbumData>> getUserAlbums();
  Future<AlbumData> createAlbum(String name);
  Future<List<AlbumData>> getSharedAlbums();
  Future<void> deleteAlbum(String id);
}

class AlbumApiRepository extends AlbumRepository {
  late ApiDatasource api;

  AlbumApiRepository() {
    api = ApiDatasource.instance;
  }

  @override
  Future<List<AlbumData>> getUserAlbums() async {
    final response = await api.get('/albums');
    
    final body = jsonDecode(response.body);
    final albums = (body['result'] as List)
      .map((picture) => AlbumData.fromJson(picture))
      .toList();

    return albums;
  }
  
  @override
  Future<AlbumData> createAlbum(String name) async {
    final newAlbum = AlbumData(name: name);
    final response = await api.post('/albums', body: newAlbum.toJson());
    return AlbumData.fromJson(jsonDecode(response.body)["result"]);
  }
  
  @override
  Future<List<AlbumData>> getSharedAlbums() async {
    final response = await api.get('/albums/shared');
    
    final body = jsonDecode(response.body);
    final albums = (body['result'] as List)
      .map((picture) => AlbumData.fromJson(picture))
      .toList();

    return albums;
  }
  
  @override
  Future<void> deleteAlbum(String id) async {
    await api.delete('/albums/$id');
  }
}

class AlbumInMemoryRepository extends AlbumRepository {
  final List<AlbumData> _albums = [
    AlbumData(
      id: '1',
      owner: '1',
      name: "Album 1",
      pictures: [
        PictureData(
          id: '1',
          name: "Picture 1",
          path: "https://picsum.photos/id/1/200/300",
          createdAt: DateTime(2021, 3, 21),
        ),
        PictureData(
          id: '2',
          name: "Picture 2",
          path: "https://picsum.photos/id/2/200/300",
          createdAt: DateTime(2021, 3, 21),
        ),
        PictureData(
          id: '3',
          name: "Picture 3",
          path: "https://picsum.photos/id/3/200/300",
          createdAt: DateTime(2021, 3, 21),
        ),
      ],
      createdAt: DateTime(2021, 4, 21),
    ),
    AlbumData(
      id: '2',
      owner: '1',
      name: "Album 2",
      pictures: [
        PictureData(
          id: '1',
          name: "Picture 1",
          path: "https://picsum.photos/id/1/200/300",
          createdAt: DateTime(2021, 3, 21),
        ),
        PictureData(
          id: '2',
          name: "Picture 2",
          path: "https://picsum.photos/id/2/200/300",
          createdAt: DateTime(2021, 3, 21),
        ),
        PictureData(
          id: '3',
          name: "Picture 3",
          path: "https://picsum.photos/id/3/200/300",
          createdAt: DateTime(2021, 3, 21),
        ),
      ],
      createdAt: DateTime(2021, 5, 21),
    ),
    AlbumData(
      id: '3',
      owner: '2',
      name: "Album 3",
      pictures: [
        PictureData(
          id: '1',
          name: "Picture 1",
          path: "https://picsum.photos/id/1/200/300",
          createdAt: DateTime(2021, 3, 21),
        ),
        PictureData(
          id: '2',
          name: "Picture 2",
          path: "https://picsum.photos/id/2/200/300",
          createdAt: DateTime(2021, 3, 21),
        ),
        PictureData(
          id: '3',
          name: "Picture 3",
          path: "https://picsum.photos/id/3/200/300",
          createdAt: DateTime(2021, 3, 21),
        ),
      ],
      createdAt: DateTime(2021, 6, 21),
    ),
  ];

  final List<String> _sharedAlbums = [
    "Album 1",
    "Album 3",
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
  
  @override
  Future<List<AlbumData>> getSharedAlbums() {
    return Future.delayed(
      const Duration(seconds: 2),
      () => _albums.where((album) => _sharedAlbums.contains(album.name)).toList(),
    );
  }
  
  @override
  Future<void> deleteAlbum(String id) {
    _albums.removeWhere((album) => album.id == id);
    return Future.delayed(
      const Duration(seconds: 2),
      () => null,
    );
  }  
}