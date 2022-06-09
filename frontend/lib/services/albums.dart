
import 'package:frontend/models/album.dart';
import 'package:frontend/repositories/album.dart';

class AlbumService {
  static AlbumService? _albumService;
  final AlbumRepository albumRepository;
  
  AlbumService({
    required this.albumRepository
  });

  static AlbumService getInstance() {
    _albumService ??= AlbumService(albumRepository: AlbumApiRepository());
    return _albumService!;
  }

  Future<List<AlbumData>> getUserAlbums() async {
    return albumRepository.getUserAlbums();
  }

  Future<AlbumData> createAlbum({required String name}) async {
    return albumRepository.createAlbum(name);
  }

  Future<List<AlbumData>> getSharedAlbums() async {
    return albumRepository.getSharedAlbums();
  }
}