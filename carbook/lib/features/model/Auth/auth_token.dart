/// Auth token model for storage
class AuthToken {
  final String accessToken;
  final String refreshToken;
  final DateTime expiryDate;
  final int userId;

  AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiryDate,
    required this.userId,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiryDate: DateTime.parse(json['expiryDate']),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiryDate': expiryDate.toIso8601String(),
      'userId': userId,
    };
  }

  bool get isExpired => DateTime.now().isAfter(expiryDate);
  
  bool get isExpiringSoon =>
      DateTime.now().add(const Duration(minutes: 5)).isAfter(expiryDate);
}
