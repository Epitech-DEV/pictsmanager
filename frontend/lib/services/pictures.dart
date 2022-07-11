
import 'package:frontend/models/picture.dart';
import 'package:frontend/models/pictures_group.dart';
import 'package:frontend/models/search_query.dart';
import 'package:frontend/repositories/picture.dart';
import 'package:frontend/shared/date.dart';

typedef DateComparator = bool Function(DateTime dateTime1, DateTime dateTime2);

class PictureService {
  PictureService({required this.pictureRepository});

  static PictureService? _instance;
  final PictureRepository pictureRepository;

  static PictureService get instance {
    _instance ??= PictureService(pictureRepository: PictureApiRepository());
    return _instance!;
  }

  Future<List<PictureData>> getUserPictures() {
    return pictureRepository.getUserPictures();
  }

  Future<List<PictureData>> getSharedPictures() {
    return pictureRepository.getSharedPictures();
  }

  Future<List<PictureData>> search(SearchQuery query) {
    return pictureRepository.search(query);
  }

  Future<void> sharePicture(String pictureId, String username) {
    return pictureRepository.sharePicture(pictureId, username);
  }

  Future<void> unsharePicture(String pictureId, String username) {
    return pictureRepository.unsharePicture(pictureId, username);
  }

  List<PicturesGroupData> generatePicturesGroups(PictureGroupType type, List<PictureData> picturesData) {
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
  List<PicturesGroupData> _generateGroups(PictureGroupType type, List<PictureData> picturesData, DateComparator dateComparator) {
    if (picturesData.isEmpty) {
      return [];
    }
    
    List<PicturesGroupData> groups = [];
    
    DateTime currentDate = picturesData[0].createdAt!;
    List<PictureData> currentPictures = [];
    
    for (PictureData data in picturesData) {
      if (dateComparator(data.createdAt!, currentDate)) {
        currentPictures.add(data);
      } else {
        groups.add(PicturesGroupData(type: type, date: currentDate, pictures: currentPictures));
        currentDate = data.createdAt!;
        currentPictures = [data];
      }
    }
    
    groups.add(PicturesGroupData(type: type, date: currentDate, pictures: currentPictures));
    return groups;
  }

  Future<void> deletePicture(String pictureId) {
    return pictureRepository.deletePicture(pictureId);
  }
}