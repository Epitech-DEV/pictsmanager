import 'package:backend/config/mongo.dart';
// import 'package:backend/models/albums.dart';
import 'package:cobalt/core/service/backend_service.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AlbumsService with BackendServiceMixin {
  DbCollection pictures = Mongo.db.collection('albums');

  // Future<Album> create(String owner, String name) {}
}
