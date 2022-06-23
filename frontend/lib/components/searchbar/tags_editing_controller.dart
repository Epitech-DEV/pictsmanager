import 'package:flutter/material.dart';

class TagsEditingController extends ChangeNotifier {
  final Set<String> _tags = {};

  void add(String tag) {
    _tags.add(tag);
    notifyListeners();
  }

  void remove(String tag) {
    _tags.remove(tag);
    notifyListeners();
  }

  void copyFrom(TagsEditingController? other) {
    if (other == null) {
      return;
    }
    _tags.clear();
    _tags.addAll(other._tags);
  }

  Set<String> get tags => _tags;
}
