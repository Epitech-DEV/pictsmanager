
class ApiError {
  final int statusCode;
  final String? code;
  final String message;

  const ApiError({
    required this.statusCode,
    this.code, 
    required this.message
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      statusCode: json['statusCode'] as int,
      code: json['errorCode'] as String?,
      message: json['message'] as String,
    );
  }
}