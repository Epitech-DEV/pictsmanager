import 'package:backend/models/albums.dart';
import 'package:backend/services/albums.dart';
import 'package:backend/services/jwt.dart';
import 'package:cobalt/backend.dart';

@ControllerInfo()
class AlbumsController with BackendControllerMixin {
  @Post(path: '/')
  Future<Map> create(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)["id"];
    String name = request.get(ParamsType.body, "name");
    Album album =
        await backend.getService<AlbumsService>()!.create(owner, name);
    return album.toJson();
  }

  @Get(path: '/')
  Future<List> get(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)["id"];

    List<Map> pictures =
        await backend.getService<AlbumsService>()!.getAll(owner);
    return pictures;
  }

  @Delete(path: '/:id')
  Future<Map> delete(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)["id"];
    String id = request.get<String>(ParamsType.params, "id")!;
    await backend.getService<AlbumsService>()!.deleteAlbum(owner, id);
    return {};
  }

  @Post(path: '/add')
  Future<Map> add(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)["id"];
    String picture = request.get<String>(ParamsType.body, "picture")!;
    String album = request.get<String>(ParamsType.body, "album")!;
    await backend
        .getService<AlbumsService>()!
        .addPicture(owner, album, picture);
    return {};
  }

  @Delete(path: '/remove')
  Future<Map> remove(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)["id"];
    String picture = request.get<String>(ParamsType.body, "picture")!;
    String album = request.get<String>(ParamsType.body, "album")!;
    await backend
        .getService<AlbumsService>()!
        .removePicture(owner, album, picture);
    return {};
  }
}
