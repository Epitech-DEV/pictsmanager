
class ApiError {
  final int code;
  final String message;

  const ApiError({
    required this.code, 
    required this.message
  });
}