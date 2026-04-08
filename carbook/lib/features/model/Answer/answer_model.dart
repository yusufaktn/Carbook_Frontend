class AnswerModel {
  int answerId;
  int questionId;
  int userId;
  String userName;
  String userLastName;
  String? profileImageUrl;
  String content;

  AnswerModel({
    required this.answerId,
    required this.questionId,
    required this.userId,
    required this.userName,
    required this.userLastName,
    this.profileImageUrl,
    required this.content,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      answerId: json['answerId'] ?? 0,
      questionId: json['questionId'] ?? 0,
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      userLastName: json['userLastName'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answerId': answerId,
      'questionId': questionId,
      'userId': userId,
      'userName': userName,
      'userLastName': userLastName,
      'profileImageUrl': profileImageUrl,
      'content': content,
    };
  }
}
