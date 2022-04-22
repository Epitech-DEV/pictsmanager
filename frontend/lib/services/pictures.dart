
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
    List<PicturesGroupData> groups = [];
    
    DateTime currentDate = picturesData[0].date;
    List<PictureData> currentPictures = [];
    
    for (PictureData data in picturesData) {
      if (dateComparator(data.date, currentDate)) {
        currentPictures.add(data);
      } else {
        groups.add(PicturesGroupData(type: type, date: currentDate, pictures: currentPictures));
        currentDate = data.date;
        currentPictures = [data];
      }
    }
    
    groups.add(PicturesGroupData(type: type, date: currentDate, pictures: currentPictures));
    return groups;
  }
}