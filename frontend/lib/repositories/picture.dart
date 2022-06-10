
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/models/picture.dart';
import 'package:frontend/models/search_query.dart';
import 'package:frontend/repositories/api.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

abstract class PictureRepository {
  Future<List<PictureData>> getUserPictures();
  Future<List<PictureData>> getSharedPictures();
  Future<List<PictureData>> search(SearchQuery query);
  Future<void> uploadPicture(File imageFile);
  Future<void> deletePicture(String pictureId);
}

class PictureApiRepository extends PictureRepository {
  late ApiDatasource api;

  PictureApiRepository() {
    api = ApiDatasource.instance;
  }

  @override
  Future<List<PictureData>> getUserPictures() async {
    final response = await api.get('/pictures');
    
    final body = jsonDecode(response.body);
      final pictures = (body['result'] as List)
        .map((picture) => PictureData.fromJson(picture))
        .toList();

    return pictures;
  }
  
  @override
  Future<List<PictureData>> getSharedPictures() async {
    final response = await api.get('/pictures/shared');
    
    final body = jsonDecode(response.body);
      final pictures = (body['result'] as List)
        .map((picture) => PictureData.fromJson(picture))
        .toList();

    return pictures;
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
  
  @override
  Future<void> deletePicture(String pictureId) async {
    await api.delete('/pictures/$pictureId');
  }
  
  @override
  Future<List<PictureData>> search(SearchQuery query) async {
    final response = await api.post('/pictures/search', body: query.toJson());

    final body = jsonDecode(response.body);
    return (body['result'] as List)
      .map((picture) => PictureData.fromJson(picture))
      .toList();
  }
}

class PictureInMemoryRepository extends PictureRepository {
  List<PictureData> userPictures = [
    PictureData(
      id: "1",
      owner: "2",
      name: 'Picture 1',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2022, 4, 22),
    ),
    PictureData(
      id: "2",
      owner: "1",
      name: 'Picture 2',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag2'],
      createdAt: DateTime(2022, 4, 22),
    ),
    PictureData(
      id: "3",
      owner: "2",
      name: 'Picture 3',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1'],
      createdAt: DateTime(2022, 4, 22),
    ),
    PictureData(
      id: "4",
      owner: "3",
      name: 'Picture 4',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag3'],
      createdAt: DateTime(2022, 4, 22),
    ),
    PictureData(
      id: "5",
      owner: "1",
      name: 'Picture 5',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag2', 'tag3'],
      createdAt: DateTime(2022, 4, 22),
    ),
    PictureData(
      id: "6",
      owner: "1",
      name: 'Picture 6',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2022, 4, 22),
    ),
    PictureData(
      id: "7",
      owner: "1",
      name: 'Picture 7',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag3'],
      createdAt: DateTime(2022, 4, 22),
    ),
    PictureData(
      id: "8",
      owner: "1",
      name: 'Picture 8',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2022, 4, 21),
    ),
    PictureData(
      id: "9",
      owner: "1",
      name: 'Picture 9',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2022, 4, 21),
    ),
    PictureData(
      id: "10",
      owner: "1",
      name: 'Picture 10',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2022, 3, 21),
    ),
    PictureData(
      id: "11",
      owner: "1",
      name: 'Picture 11',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "12",
      owner: "1",
      name: 'Picture 12',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "13",
      owner: "1",
      name: 'Picture 13',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "14",
      owner: "1",
      name: 'Picture 14',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "15",
      owner: "1",
      name: 'Picture 15',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "16",
      owner: "1",
      name: 'Picture 16',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "17",
      owner: "1",
      name: 'Picture 17',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "18",
      owner: "1",
      name: 'Picture 18',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "19",
      owner: "1",
      name: 'Picture 19',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "20",
      owner: "1",
      name: 'Picture 20',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "21",
      owner: "1",
      name: 'Picture 21',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "22",
      owner: "1",
      name: 'Picture 22',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "23",
      owner: "1",
      name: 'Picture 23',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "24",
      owner: "1",
      name: 'Picture 24',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "25",
      owner: "1",
      name: 'Picture 25',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "26",
      owner: "1",
      name: 'Picture 26',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "27",
      owner: "1",
      name: 'Picture 27',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "28",
      owner: "1",
      name: 'Picture 28',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "29",
      owner: "1",
      name: 'Picture 29',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "30",
      owner: "1",
      name: 'Picture 30',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "31",
      owner: "1",
      name: 'Picture 31',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "32",
      owner: "1",
      name: 'Picture 32',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "33",
      owner: "1",
      name: 'Picture 33',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "34",
      owner: "1",
      name: 'Picture 34',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "35",
      owner: "1",
      name: 'Picture 35',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "36",
      owner: "1",
      name: 'Picture 36',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "37",
      owner: "1",
      name: 'Picture 37',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "38",
      owner: "1",
      name: 'Picture 38',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "39",
      owner: "1",
      name: 'Picture 39',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
    ),
    PictureData(
      id: "40",
      owner: "1",
      name: 'Picture 40',
      path: 'https://picsum.photos/id/11/760/380',
      tags: ['tag1', 'tag2'],
      createdAt: DateTime(2021, 3, 21),
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

  @override
  Future<void> deletePicture(String pictureId) {
    userPictures.removeWhere((element) => element.id == pictureId);
    return Future.delayed(const Duration(seconds: 2));
  }
  
  @override
  Future<List<PictureData>> search(SearchQuery query) {
    // TODO: implement search
    throw UnimplementedError();
  }
}