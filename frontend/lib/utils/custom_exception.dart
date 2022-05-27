class CustomException implements Exception {
  String message;
  int errorCode;

  CustomException({
    required this.message,
    required this.errorCode,
  });

  int get getErrorCode => errorCode;
  String get getMessage => message;
}
