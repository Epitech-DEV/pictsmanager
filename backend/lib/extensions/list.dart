import 'dart:core';
import 'dart:collection';

extension ListExtension<T> on List<T> {
  void addIfAbsent(T element) {
    if (!contains(element)) {
      add(element);
    }
  }
}
