class Validators {
  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Field is empty";
    }
    return null;
  }

  static String? loginPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Field is empty";
    }
    return null;
  }

  static String? registerPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Field is empty";
    }
    if (value.length < 8) {
      return "Password isn't long enough";
    }
    return null;
  }
}
