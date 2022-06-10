extension ListExt<T> on List<T> {
  T? find(bool Function(T elem) predicate) {
    for (T listElement in this) {
      if (predicate(listElement)) {
        return listElement;
      }
    }
    return null;
  }
}
