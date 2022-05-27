import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/album.dart';
import 'package:frontend/repositories/album.dart';
import 'package:frontend/services/albums.dart';

void main() {
  final AlbumService albumService = AlbumService(albumRepository: AlbumInMemoryRepository());
  
  group('Testing the method [AlbumService.getUserAlbums]', () {
    test('Should return 3 [AlbumData]', () async {
      final List<AlbumData> albums = await albumService.getUserAlbums();
      expect(albums.length, 3);
    });
  });

  group('Testing the method [AlbumService.createAlbum]', () {
    test('Should return 4 [AlbumData]', () async {
      await albumService.createAlbum(name: 'New test album');
      final List<AlbumData> albums = await albumService.getUserAlbums();
      expect(albums.length, 4);
    });
  });
}