extension NumberString on int {
  String padLeft(int size) {
    return toString().padLeft(size, '0');
  }
}
