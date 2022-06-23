import 'package:flutter/material.dart';
import 'package:frontend/components/searchbar/number_extension.dart';

class DateEditingController extends ChangeNotifier {
  DateTime _start = DateTime.now();
  TextEditingController controller = TextEditingController();

  void setDate(DateTime value) {
    _start = value;
    controller.text =
        '${_start.day.padLeft(2)}/${_start.month.padLeft(2)}/${_start.year.padLeft(4)}';
    controller.notifyListeners();
    notifyListeners();
  }

  DateTime get date => _start;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void copyFrom(DateEditingController? other) {
    if (other == null) {
      return;
    }
    _start = other._start;
    controller.text = other.controller.text;
  }
}
