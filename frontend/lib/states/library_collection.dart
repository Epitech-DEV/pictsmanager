
import 'dart:async';

import 'package:frontend/models/album.dart';

class LibraryCollectionController {
  static LibraryCollectionController? _instance;

  LibraryCollectionController._();

  static LibraryCollectionController get instance {
    _instance ??= LibraryCollectionController._();
    return _instance!;
  }

  final Stream<List<AlbumData>> _albums = Stream.fromIterable([]);
  
  Stream<List<AlbumData>> get albums => _albums;

}