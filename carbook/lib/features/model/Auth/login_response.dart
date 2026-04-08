/// Login response model
class LoginResponse {
  final bool success;
  final String? message;
  final String? accessToken;
  final String? refreshToken;
  final DateTime? expiryDate;
  final int? userId;
  final String? email;
  final String? userName;
  final String? userLastName;

  LoginResponse({
    required this.success,
    this.message,
    this.accessToken,
    this.refreshToken,
    this.expiryDate,
    this.userId,
    this.email,
    this.userName,
    this.userLastName,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
      userId: json['userId'],
      email: json['email'],
      userName: json['userName'],
      userLastName: json['userLastName'],
    );
  }

  String get fullName =>
      userName != null && userLastName != null
          ? '$userName $userLastName'
          : '';
}
