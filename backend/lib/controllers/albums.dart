import 'package:backend/models/albums.dart';
import 'package:backend/services/albums.dart';
import 'package:backend/services/jwt.dart';
import 'package:cobalt/backend.dart';

@ControllerInfo()
class AlbumsController with BackendControllerMixin {
  @Get(path: '/shared')
  Future<List<Map>> getShared(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)["id"];

    final List<Map> shared =
        await backend.getService<AlbumsService>()!.getShared(owner);
    return shared;
  }

  @Post(path: '/share')
  Future<Map> addPermissions(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)["id"];
    List<String> albums = List<String>.from(
      request.get(ParamsType.body, "albums"),
    );
    List<String> users = List<String>.from(
      request.get(ParamsType.body, "users"),
    );
    await backend
        .getService<AlbumsService>()!
        .addPermissions(owner, albums, users);
    return {};
  }

  @Post(path: '/unshare')
  Future<Map> removePermissions(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)["id"];
    List<String> albums = List<String>.from(
      request.get(ParamsType.body, "albums"),
    );
    List<String> users = List<String>.from(
      request.get(ParamsType.body, "users"),
    );
    await backend
        .getService<AlbumsService>()!
        .removePermissions(owner, albums, users);
    return {};
  }

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

  @Delete(path: '/pictures')
  Future<Map> deletePictures(BackendRequest request) async {
    JWTService jwtService = backend.getService<JWTService>()!;
    String owner = jwtService.verify(request)["id"];
    String album = request.get(ParamsType.body, "album");
    List<String> pictures =
        List<String>.from(request.get(ParamsType.body, "pictures"));
    await backend
        .getService<AlbumsService>()!
        .deletePictures(owner, album, pictures);
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
