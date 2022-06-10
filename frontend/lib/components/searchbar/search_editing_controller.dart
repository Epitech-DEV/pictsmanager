import 'package:flutter/material.dart';

import 'date_editing_controller.dart';
import 'tags_editing_controller.dart';

class SearchEditingController extends ChangeNotifier {
  TextEditingController keywordController = TextEditingController();
  TagsEditingController tagsController = TagsEditingController();
  DateEditingController fromDateController = DateEditingController();
  DateEditingController toDateController = DateEditingController();
  ValueNotifier<bool> useDateRange = ValueNotifier(false);

  @override
  void dispose() {
    keywordController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  void copyFrom(SearchEditingController? other) {
    if (other == null) {
      return;
    }
    keywordController.text = other.keywordController.text;
    tagsController.tags.clear();
    tagsController.tags.addAll(other.tagsController.tags);
    fromDateController.copyFrom(other.fromDateController);
    toDateController.copyFrom(other.toDateController);
    useDateRange.value = other.useDateRange.value;
  }
}
