

import 'package:flutter/widgets.dart';
import 'package:frontend/models/album.dart';
import 'package:frontend/services/albums.dart';

class LibraryCollectionController extends ChangeNotifier {
  static LibraryCollectionController? _instance;

  LibraryCollectionController._();

  static LibraryCollectionController get instance {
    _instance ??= LibraryCollectionController._();
    return _instance!;
  }

  late AlbumService _albumService;
  late VoidCallback _reloadCallback;
  late Future<List<AlbumData>> _loadFuture;

  Future<List<AlbumData>> get loadFuture => _loadFuture;

  Future<void> init(AlbumService service, VoidCallback reloadCallback) async {
    _albumService = service;
    _loadFuture = _albumService.getUserAlbums();
    _reloadCallback = reloadCallback;
  }

  void reload() {
    _loadFuture = _albumService.getUserAlbums();
    _reloadCallback();
  }
}