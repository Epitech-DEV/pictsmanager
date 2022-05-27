import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:frontend/models/picture.dart';
import 'package:frontend/models/pictures_group.dart';
import 'package:frontend/repositories/picture.dart';
import 'package:frontend/shared/date.dart';

typedef DateComparator = bool Function(DateTime dateTime1, DateTime dateTime2);

class PictureService {
  PictureService({required this.pictureRepository});

  final PictureRepository pictureRepository;

  Future<List<PictureData>> getUserPictures() {
    return pictureRepository.getUserPictures();
  }

  List<PicturesGroupData> generatePicturesGroups(
      PictureGroupType type, List<PictureData> picturesData) {
    switch (type) {
      case PictureGroupType.day:
        return _generateGroups(type, picturesData, Date.isTheSameDay);
      case PictureGroupType.month:
        return _generateGroups(type, picturesData, Date.isTheSameMonth);
      case PictureGroupType.year:
        return _generateGroups(type, picturesData, Date.isTheSameYear);
    }
  }

  /// Generate a list of [PicturesGroupData] for the given [picturesData]
  /// Groups are created by the [dateComparator] function.
  List<PicturesGroupData> _generateGroups(PictureGroupType type,
      List<PictureData> picturesData, DateComparator dateComparator) {
    List<PicturesGroupData> groups = [];

    DateTime currentDate = picturesData[0].date;
    List<PictureData> currentPictures = [];

    for (PictureData data in picturesData) {
      if (dateComparator(data.date, currentDate)) {
        currentPictures.add(data);
      } else {
        groups.add(PicturesGroupData(
            type: type, date: currentDate, pictures: currentPictures));
        currentDate = data.date;
        currentPictures = [data];
      }
    }

    groups.add(PicturesGroupData(
        type: type, date: currentDate, pictures: currentPictures));
    return groups;
  }

  Future<void> upload(File imageFile) async {
    // open a bytestream
    var stream = http.ByteStream(imageFile.openRead());
    stream.cast();
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse('http://10.101.9.1:8080/auth/login');

    // create multipart request
    var request = http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
}
