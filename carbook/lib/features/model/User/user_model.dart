class UserModel {
  int userId;
  String userName;
  String userLastName;
  String email;
  String? profileImageUrl;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userLastName,
    required this.email,
    this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      userLastName: json['userLastName'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userLastName': userLastName,
      'email': email,
      'profileImageUrl': profileImageUrl,
    };
  }

  String get fullName => '$userName $userLastName';
  String get initials => '${userName.isNotEmpty ? userName[0].toUpperCase() : ''}${userLastName.isNotEmpty ? userLastName[0].toUpperCase() : ''}';
  
  // copyWith metodu - profil güncellemesi için
  UserModel copyWith({
    int? userId,
    String? userName,
    String? userLastName,
    String? email,
    String? profileImageUrl,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userLastName: userLastName ?? this.userLastName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
