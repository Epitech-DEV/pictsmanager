import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/picture.dart';
import 'package:frontend/models/pictures_group.dart';
import 'package:frontend/repositories/picture.dart';
import 'package:frontend/services/pictures.dart';

void main() {
  final PictureService pictureService = PictureService(pictureRepository: PictureInMemoryRepository());

  group("Testing [Pictures.getPicture] method", () {
    test("Should return 11 [PictureData]", () async {
      final List<PictureData> pictures = await pictureService.getUserPictures();
      expect(pictures.length, 40);
    });
  });

  group("Testing [Pictures.generatePicturesGroups] method", () {
    late List<PictureData> pictures;

    setUpAll(() async {
      pictures = await pictureService.getUserPictures();
    });

    test("Should return 1 [PictureGroupData] if grouped by day", () async {
      final List<PicturesGroupData> groups = pictureService.generatePicturesGroups(PictureGroupType.day, pictures);
      expect(groups.length, 4);
    });

    test("Should return 1 [PictureGroupData] if grouped by month", () async {
      final List<PicturesGroupData> groups = pictureService.generatePicturesGroups(PictureGroupType.month, pictures);
      expect(groups.length, 3);
    });

    test("Should return 1 [PictureGroupData] if grouped by year", () async {
      final List<PicturesGroupData> groups = pictureService.generatePicturesGroups(PictureGroupType.year, pictures);
      expect(groups.length, 2);
    });
  });
}