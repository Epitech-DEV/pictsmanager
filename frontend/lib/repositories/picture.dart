
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/models/picture.dart';
import 'package:frontend/repositories/api.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

abstract class PictureRepository {
  Future<List<PictureData>> getUserPictures();
  Future<List<PictureData>> getSharedPictures();
  Future<void> uploadPicture(File imageFile);
}

class PictureApiRepository extends PictureRepository {
  late ApiDatasource api;

  PictureApiRepository() {
    api = ApiDatasource.instance;
  }

  @override
  Future<List<PictureData>> getUserPictures() {
    throw UnimplementedError();
  }
  
  @override
  Future<List<PictureData>> getSharedPictures() {
    // TODO: implement getSharedPictures
    throw UnimplementedError();
  }
  
  @override
  Future<void> uploadPicture(File imageFile) async {
    var imageStream = http.ByteStream(imageFile.openRead());
    imageStream.cast();

    var imageLength = await imageFile.length();
    var imageMultipartFile = http.MultipartFile('file', imageStream, imageLength,
        filename: basename(imageFile.path));

    // TODO: implement uploadPicture
    final response = await api.multipart('auth/login', [imageMultipartFile]);
    debugPrint(response.statusCode.toString());

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      debugPrint(value);
    });
  }
}

class PictureInMemoryRepository extends PictureRepository {
  List<PictureData> userPictures = [
    PictureData(
      name: 'Picture 1',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2022, 4, 22),
    ),
    PictureData(
      name: 'Picture 2',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag2'],
      date: DateTime(2022, 4, 22),
    ),
    PictureData(
      name: 'Picture 3',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1'],
      date: DateTime(2022, 4, 22),
    ),
    PictureData(
      name: 'Picture 4',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag3'],
      date: DateTime(2022, 4, 22),
    ),
    PictureData(
      name: 'Picture 5',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag2', 'tag3'],
      date: DateTime(2022, 4, 22),
    ),
    PictureData(
      name: 'Picture 6',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2022, 4, 22),
    ),
    PictureData(
      name: 'Picture 7',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag3'],
      date: DateTime(2022, 4, 22),
    ),
    PictureData(
      name: 'Picture 8',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2022, 4, 21),
    ),
    PictureData(
      name: 'Picture 9',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2022, 4, 21),
    ),
    PictureData(
      name: 'Picture 10',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2022, 3, 21),
    ),
    PictureData(
      name: 'Picture 11',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 12',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 13',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 14',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 15',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 16',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 17',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 18',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 19',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 20',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 21',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 22',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 23',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 24',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 25',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 26',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 27',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 28',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 29',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 30',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 31',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 32',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 33',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 34',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 35',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 36',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 37',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 38',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 39',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
    PictureData(
      name: 'Picture 40',
      url: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      date: DateTime(2021, 3, 21),
    ),
  ];
  List<String> sharedPictures = [
    "Picture 1",
    "Picture 3",
    "Picture 4",
    "Picture 5",
    "Picture 8",
    "Picture 9",
    "Picture 10",
    "Picture 12",
    "Picture 13",
    "Picture 14",
    "Picture 15",
  ];


  @override
  Future<List<PictureData>> getUserPictures() {
    return Future.delayed(
      const Duration(seconds: 2),
      () => userPictures,
    );
  }
  
  @override
  Future<List<PictureData>> getSharedPictures() {
    return Future.delayed(
      const Duration(seconds: 2),
      () => userPictures.where((element) => sharedPictures.contains(element.name)).toList(),
    );
  }
  
  @override
  Future<void> uploadPicture(File imageFile) {
    return Future.delayed(const Duration(seconds: 2));
  }
}
