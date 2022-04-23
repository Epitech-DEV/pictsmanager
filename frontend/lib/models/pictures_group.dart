
import 'package:flutter/widgets.dart';
import 'package:frontend/models/picture.dart';

enum PictureGroupType {
  day,
  month,
  year,
}

class PictureGroupTypeUtils {
  static PictureGroupType previous(PictureGroupType current) {
    switch (current) {
      case PictureGroupType.year:
        return PictureGroupType.month;
      case PictureGroupType.month:
        return PictureGroupType.day;
      default:
        return current;
    }
  }

  static PictureGroupType next(PictureGroupType current) {
    switch (current) {
      case PictureGroupType.day:
        return PictureGroupType.month;
      case PictureGroupType.month:
        return PictureGroupType.year;
      default:
        return current;
    }
  }
}

class PicturesGroupData extends ChangeNotifier {
  PicturesGroupData({
    required this.type,
    required this.date,
    required this.pictures,
  });

  final PictureGroupType type;
  final DateTime date;
  final List<PictureData> pictures;

  int get day => date.day;
  int get month => date.month;
  int get year => date.year;
  
  int get length => pictures.length;
  PictureData operator [](int index) => pictures[index];

  void add(PictureData picture) {
    pictures.add(picture);
    notifyListeners();
  }

  void addAll(List<PictureData> pictures) {
    this.pictures.addAll(pictures);
    notifyListeners();
  }

  void remove(PictureData picture) {
    pictures.remove(picture);
    notifyListeners();
  }

  void removeAt(int index) {
    pictures.removeAt(index);
    notifyListeners();
  }

  void clear() {
    pictures.clear();
    notifyListeners();
  }
}