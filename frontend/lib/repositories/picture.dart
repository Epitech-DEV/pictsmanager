
import 'package:frontend/models/picture.dart';

abstract class PictureRepository {
  Future<List<PictureData>> getUserPictures();
}

class PictureApiRepository extends PictureRepository {
  @override
  Future<List<PictureData>> getUserPictures() {
    // TODO: implement getUserPicture
    throw UnimplementedError();
  }
}

class PictureInMeromryRepository extends PictureRepository {
  List<PictureData> userPictures = [
    PictureData(
      name: 'Picture 1',
      url: 'https://picsum.photos/id/1/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2022, 4, 22),
    ),
    PictureData(
      name: 'Picture 2',
      url: 'https://picsum.photos/id/2/760/380',
      tags: ['tag2'],
      date: DateTime(2022, 4, 22),
    ),
    PictureData(
      name: 'Picture 3',
      url: 'https://picsum.photos/id/3/760/380',
      tags: ['tag1'],
      date: DateTime(2022, 4, 22),
    ),
    PictureData(
      name: 'Picture 4',
      url: 'https://picsum.photos/id/4/760/380',
      tags: ['tag3'],
      date: DateTime(2022, 4, 22),
    ),
    PictureData(
      name: 'Picture 5',
      url: 'https://picsum.photos/id/5/760/380',
      tags: ['tag2', 'tag3'],
      date: DateTime(2022, 4, 22),
    ),
    PictureData(
      name: 'Picture 6',
      url: 'https://picsum.photos/id/6/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2022, 4, 22),
    ),
    PictureData(
      name: 'Picture 7',
      url: 'https://picsum.photos/id/7/760/380',
      tags: ['tag1', 'tag3'],
      date: DateTime(2022, 4, 22),
    ),
    PictureData(
      name: 'Picture 8',
      url: 'https://picsum.photos/id/8/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2022, 4, 21),
    ),
    PictureData(
      name: 'Picture 9',
      url: 'https://picsum.photos/id/9/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2022, 4, 21),
    ),
    PictureData(
      name: 'Picture 10',
      url: 'https://picsum.photos/id/10/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2022, 3, 21),
    ),
    PictureData(
      name: 'Picture 11',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
  ];

  @override
  Future<List<PictureData>> getUserPictures() {
    return Future.delayed(
      const Duration(seconds: 2),
      () => userPictures,
    );
  }
}