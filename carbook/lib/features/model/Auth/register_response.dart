/// Register response model
class RegisterResponse {
  final bool success;
  final String? message;
  final int? userId;

  RegisterResponse({
    required this.success,
    this.message,
    this.userId,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] ?? false,
      message: json['message'],
      userId: json['userId'],
    );
  }
}
